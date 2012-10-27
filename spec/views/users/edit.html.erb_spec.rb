require 'spec_helper'

describe "users/edit" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :account => "MyString",
      :name => "MyString",
      :notify_email => "MyString",
      :refresh_token => "MyString",
      :auth_token => "MyString",
      :error_count => 1,
      :suspended => false,
      :check_target => "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path(@user), :method => "post" do
      assert_select "input#user_account", :name => "user[account]"
      assert_select "input#user_name", :name => "user[name]"
      assert_select "input#user_notify_email", :name => "user[notify_email]"
      assert_select "input#user_refresh_token", :name => "user[refresh_token]"
      assert_select "input#user_auth_token", :name => "user[auth_token]"
      assert_select "input#user_error_count", :name => "user[error_count]"
      assert_select "input#user_suspended", :name => "user[suspended]"
      assert_select "input#user_check_target", :name => "user[check_target]"
    end
  end
end
