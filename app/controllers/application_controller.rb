class ApplicationController < ActionController::Base
  class MyResponder < ActionController::Responder
    include Responders::FlashResponder
  end
  protect_from_forgery
  respond_to :html, :xml, :json
  self.responder = MyResponder

  before_filter :set_locale, :set_time_zone

  rescue_from CanCan::AccessDenied do |exception|
    render :text => exception.message, :status => 403
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error "[RecordNotFound] #{exception.message}\n"+exception.backtrace.join("\n")
    render_404
  end

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404.html", :status => :not_found }
      format.xml  { head :not_found, :status => :not_found }
      format.any  { head :not_found, :status => :not_found }
    end
  end

  private
  def set_locale
    supported_locale = %w(en ja)
    logger.debug "Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    request.env['HTTP_ACCEPT_LANGUAGE'].to_s.split(/\s,\s/).each do |l|
      supported_locale.member?(l[0..1]) or next
      I18n.locale = l[0..1].to_sym
    end
    logger.debug "Locale set to '#{I18n.locale}'"
    if user_signed_in? && current_user.locale.to_s != I18n.locale.to_s
      logger.debug "Update user (#{current_user.account}) locale field '#{current_user.locale}' -> '#{I18n.locale}'"
      current_user.update_attribute :locale, I18n.locale.to_s
    end
    controller_name == "main" and I18n.locale = :en
    true
  end

  def set_time_zone
    user_signed_in? or return true
    Time.zone = current_user.time_zone
    true
  end
end
