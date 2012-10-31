class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      flash[:notice] = I18n.t "devise.omniauth_callbacks.failed", :kind => "Google"
      redirect_to welcome_login_failed_path
    end
  end

  def after_omniauth_failure_path_for(scope)
    root_path
  end
end
