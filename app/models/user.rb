class User < ActiveRecord::Base
  class GoogleAPIError < StandardError
    def initialize(result, msg)
      @api_result = result
      super(msg)
    end
    attr_accessor :api_result
  end

  attr_accessible :account, :auth_token, :check_target, :error_count,
    :last_checked_at, :last_notified_at, :name, :notify_email,
    :refresh_token, :suspended, :token_expires_at, :token_issued_at

  check_target_enums = %w(default all own starred)
  enum_attr :check_target, check_target_enums do
    check_target_enums.each do |choice|
      label choice.to_sym => I18n.t(choice, :scope => [:enumerated_attribute, :user, :check_target])
    end
  end

  BACKWARD_LIMIT = 7.days

  def admin?
    Rails.configuration.admin_users.member? self.account
  end

  def type_serach_query
    case self.check_target
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

  def unread_files
    updated_files.find_all { |i|
      !i["lastViewedByMeDate"] || i["modifiedDate"] > i["lastViewedByMeDate"]
    }
  end

  def updated_files
    start_date_limit = DateTime.now - BACKWARD_LIMIT
    start_date = last_checked_at || start_date_limit
    start_date < start_date_limit and start_date = start_date_limit
    check_stamp = DateTime.now
    params = {:q => [type_serach_query, "modifiedDate >= '#{start_date.to_datetime.utc.strftime("%FT%TZ")}'"].compact.join(' and ')}
    ret = []
    loop do
      result = gapi_request :list, params
      if block_given?
        result.data.items.each do |item|
          ret << yield(item)
        end
      else
        ret << result.data.items.to_a
      end
      result.next_page_token or break
      params[:pageToken] = result.next_page_token
    end
    update_attribute :last_checked_at, check_stamp
    ret.flatten
  end

  private
  def update_gapi_client_token
    @gapi_client or return
    auth = @gapi_client.authorization
    auth.expired? or return
    logger.debug "Google API: access token has been expired, trying refresh..."
    auth.fetch_access_token!
    self.update_attributes!({
                              :token_expires_at => auth.expires_at,
                              :token_issued_at  => auth.issued_at,
                              :auth_token       => auth.access_token,
                              :refresh_token    => auth.refresh_token,
                            })
    logger.debug "Google API: access token refresh success."
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
                         :access_token => auth_token,
                         :refresh_token => refresh_token,
                         :expires_in => token_expires_at.to_i - token_issued_at.to_i - 30, # -30 sec for early refresh...
                         :issued_at => token_issued_at,
                       })
    @gapi_client = gac
    update_gapi_client_token
    gac
  end

  def gapi_request(method, params = {}, body = nil)
    client = gapi_client
    service = client.discovered_api('drive', 'v2')
    greq = {
      :headers => {'Content-Type' => 'application/json'},
      :api_method => service.files.__send__(method),
      :parameters => {}.merge(params),
    }
    body and greq[:body] = body
    greq_orig = greq.dup
    logger.debug "Execute Google API request #{greq[:api_method].id}"
    result = client.execute(greq)
    if result.status < 200 || result.status >= 300
      msg = "Error on Google calendar API '#{method}': status=#{result.status}, request=#{greq_orig.inspect} response=#{result.body}"
      logger.error msg
      logger.error result.pretty_inspect
      raise GoogleAPIError.new(result, msg)
    end
    logger.debug "API request #{greq[:api_method].id} success (status=#{result.status})"
    result
  end
end
