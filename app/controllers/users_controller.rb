class UsersController < ApplicationController
  def index
    @users = User.all
    respond_with(@users)
  end

  def show
    @user = User.find(params[:id])
    respond_with(@user)
  end

  def new
    @user = User.new
    respond_with(@user)
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    @user.save
    respond_with(@user)
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    respond_with(@user)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_with(@user)
  end

  def auth_callback
    @auth = request.env["omniauth.auth"]
    user = User.find_by_account(@auth.uid) || User.new(:account => @auth.uid)

    c = @auth["credentials"]
    $stderr.puts @auth.inspect
    user.attributes = {
      :auth_token       => c.token,
      :refresh_token    => c.refresh_token,
      :token_expires_at => Time.at(c.expires_at).to_datetime,
      :token_issued_at  => DateTime.now,
    }
    user.save
    redirect_to(user)
  end
end
