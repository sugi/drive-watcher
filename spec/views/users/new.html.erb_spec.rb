require 'spec_helper'

describe "users/new" do
  before(:each) do
    assign(:user, stub_model(User,
      :account => "MyString",
      :notify_email => "MyString",
      :refresh_token => "MyString",
      :auth_token => "MyString",
      :error_count => 1,
      :suspended => false,
      :check_target => "all"
    ).as_new_record)
  end

  it "renders new user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path, :method => "post" do
      assert_select "input#user_account", :name => "user[account]"
      assert_select "input#user_notify_email", :name => "user[notify_email]"
      assert_select "input#user_refresh_token", :name => "user[refresh_token]"
      assert_select "input#user_auth_token", :name => "user[auth_token]"
      assert_select "input#user_error_count", :name => "user[error_count]"
      assert_select "input#user_suspended", :name => "user[suspended]"
      assert_select "select#user_check_target", :name => "user[check_target]"
    end
  end
end
