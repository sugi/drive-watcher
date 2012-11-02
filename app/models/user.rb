class User < ActiveRecord::Base
  class GoogleAPIError < StandardError
    def initialize(result, msg)
      @api_result = result
      super(msg)
    end
    attr_accessor :api_result
  end

  devise :omniauthable

  attr_accessible :account, :auth_token, :check_target,
    :last_checked_at, :last_notified_at, :notify_email,
    :refresh_token, :suspended, :token_expires_at,
    :token_issued_at, :check_interval, :locale, :time_zone

  validates :error_count, :numericality => { :only_integer => true }, :allow_nil => true
  validates :check_interval, :numericality => { :only_integer => true, :greater_than => 0 }, :allow_nil => true
  validates :locale, :length => { :is => 2 }, :allow_nil => true

  check_target_enums = %w(default all own starred)
  enum_attr :check_target, check_target_enums do
    check_target_enums.each do |choice|
      label choice.to_sym => I18n.t(choice, :scope => [:enumerated_attribute, :user, :check_target])
    end
  end

  scope :active, where(:suspended => false)

  BACKWARD_LIMIT = 7.days

  class << self
    def find_for_google_oauth2(auth, signed_in_resource=nil)
      !auth || !auth.uid and return nil
      u = find_by_account(auth.uid) || new(:account => auth.uid)

      c = auth["credentials"]
      u.update_attributes!({
        :auth_token       => c.token,
        :refresh_token    => c.refresh_token,
        :token_expires_at => Time.at(c.expires_at).to_datetime,
        :token_issued_at  => DateTime.now,
        :notify_email     => auth["info"]["email"],
      })
      u.save!
      u
    end
  end

  def uid;     account;     end
  def uid=(v); account = v; end
  def email;     notify_email;     end
  def email=(v); notify_email = v; end

  def provider
    :google_oauth2
  end

  def admin?
    Rails.configuration.admin_users.member? self.account
  end

  def type_serach_query
    case self.check_target.to_s
    when "all"
      nil
    when "starred"
      "starred = true"
    when "own"
      "'#{account}' in owners"
    else # "default"
      "hidden = false"
    end
  end

  def send_unread_notify(opts = {})
    unread_files(opts).empty? and return false
    logger.info "[User #{account}] #{unread_files.count} unread files found. Sending notification"
    UserMailer.notify_unread(self).deliver
    update_attribute :last_notified_at, DateTime.now
    update_attribute :notify_count,     notify_count + 1
  end

  def unread_files(opts = {})
    updated_files(opts).find_all { |i|
      !i["lastViewedByMeDate"] || i["modifiedDate"] > i["lastViewedByMeDate"]
    }
  end

  def updated_files(opts = {})
    opts = {:reload => false}.merge(opts)
    !opts[:reload] && @_updated_files and return @_updated_files
    start_date_limit = DateTime.now - BACKWARD_LIMIT
    start_date = last_checked_at || start_date_limit
    start_date < start_date_limit and start_date = start_date_limit
    check_stamp = DateTime.now
    params = {:q => [type_serach_query,
      "modifiedDate >= '#{start_date.to_datetime.utc.strftime("%FT%TZ")}'",
      "mimeType != 'application/vnd.google-apps.folder'"
    ].compact.join(' and ')}
    ret = []
    loop do
      logger.debug "[User #{account}] send API request to get files param=#{params.inspect}"
      result = gapi_request :list, params
      logger.debug "[User #{account}] file list API request success."
      ret << result.data.items.to_a
      result.next_page_token or break
      logger.debug "[User #{account}]: file list: Next page found. try again"
      params[:pageToken] = result.next_page_token
    end
    logger.debug "[User #{account}] Getting files completed. Updateing stamp..."
    update_attribute :last_checked_at, check_stamp
    @_updated_files = ret.flatten
  end

  private
  def update_gapi_client_token
    @gapi_client or return
    auth = @gapi_client.authorization
    auth.expired? or return
    logger.debug "[User #{account}] Google API: access token has been expired, trying refresh..."
    auth.fetch_access_token!
    self.update_attributes!({
                              :token_expires_at => auth.expires_at,
                              :token_issued_at  => auth.issued_at,
                              :auth_token       => auth.access_token,
                              :refresh_token    => auth.refresh_token,
                            })
    logger.debug "[User #{account}] Google API: access token refresh success."
  end

  def gapi_client
    if @gapi_client
      update_gapi_client_token
      return @gapi_client
    end
    gac = Google::APIClient.new
    auth = gac.authorization
    auth.client_id     = Rails.configuration.google_client_id
    auth.client_secret = Rails.configuration.google_client_secret
    
    auth.update_token!({
                         :access_token  => auth_token,
                         :refresh_token => refresh_token,
                         :expires_in    => token_expires_at.to_i - token_issued_at.to_i - 30, # -30 sec for early refresh...
                         :issued_at     => token_issued_at,
                       })
    @gapi_client = gac
    update_gapi_client_token
    gac
  end

  def gapi_request(method, params = {}, body = nil)
    client = gapi_client
    service = client.discovered_api('drive', 'v2')
    greq = {
      :headers    => {'Content-Type' => 'application/json'},
      :api_method => service.files.__send__(method),
      :parameters => {}.merge(params),
    }
    body and greq[:body] = body
    greq_orig = greq.dup
    logger.debug "[User #{account}] Execute Google API request #{greq[:api_method].id}"
    result = client.execute(greq)
    if result.status < 200 || result.status >= 300
      msg = "Error on Google calendar API '#{method}': status=#{result.status}, request=#{greq_orig.inspect} response=#{result.body}"
      logger.error "[User #{account}] #{msg}"
      #logger.error "[User #{account}] #{result.pretty_inspect}"
      raise GoogleAPIError.new(result, msg)
    end
    logger.debug "[User #{account}] API request #{greq[:api_method].id} success (status=#{result.status})"
    result
  end
end
