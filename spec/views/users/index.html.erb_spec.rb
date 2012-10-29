require 'spec_helper'

describe "users/index" do
  before(:each) do
    assign(:users, [
      stub_model(User,
        :account => "Account",
        :name => "Name",
        :notify_email => "Notify Email",
        :refresh_token => "Refresh Token",
        :auth_token => "Auth Token",
        :error_count => 1,
        :suspended => false,
        :check_target => "default"
      ),
      stub_model(User,
        :account => "Account",
        :name => "Name",
        :notify_email => "Notify Email",
        :refresh_token => "Refresh Token",
        :auth_token => "Auth Token",
        :error_count => 1,
        :suspended => false,
        :check_target => "default"
      )
    ])
  end

  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Account".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Notify Email".to_s, :count => 2
    assert_select "tr>td", :text => "Refresh Token".to_s, :count => 2
    assert_select "tr>td", :text => "Auth Token".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "default".to_s, :count => 2
  end
end
