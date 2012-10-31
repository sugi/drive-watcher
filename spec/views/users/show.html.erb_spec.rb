require 'spec_helper'

check_stamp = DateTime.now
notify_stamp = DateTime.now

describe "users/show" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :id => 70,
      :account => "Account",
      :name => "Name",
      :notify_email => "Notify@Email",
      :refresh_token => "Refresh Token",
      :auth_token => "Auth Token",
      :error_count => 1,
      :suspended => false,
      :check_target => "default",
      :last_checked_at => check_stamp,
      :last_notified_at => notify_stamp,
    ))
  end

  it "check rendered content" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Notify@Email/)
    pending("I18n.l timezone is differ between test runner and Rails") do
      rendered.should match(I18n.l(notify_stamp))
    end
    assert_select %Q{form[action="/users/<%= @user.id %>"]}, true
    assert_select %Q{*[name="user[check_internal]"]}, true
    assert_select %Q{*[name="user[check_target]"]}, true
  end
end
