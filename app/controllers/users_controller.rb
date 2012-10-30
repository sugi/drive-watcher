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
    respond_with(@user, :location => @user == current_user ? root_path : users_path)
  end

  def check
    @user = User.find(params[:id])
    @files = @user.unread_files
    @user.notify_unread
    respond_with @files,
      :location => user_path(:id => @user.id, :anchor => 'manage'),
      :notice => I18n.t("unread_files_found", :num => @files.size)
  end

  def reset_stamp
    @user = User.find(params[:id])
    @user.update_attribute :last_checked_at, nil
    respond_with @user, :notice => I18n.t("reset_stamp_success"),
      :location => user_path(:id => @user.id, :anchor => 'manage')
  end
end
