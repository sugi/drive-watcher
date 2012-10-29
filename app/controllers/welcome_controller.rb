class WelcomeController < ApplicationController
  def index
    user_signed_in? and redirect_to edit_user_path(current_user)
  end
end
