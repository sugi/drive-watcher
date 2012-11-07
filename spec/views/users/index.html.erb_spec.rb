require 'spec_helper'

describe "users/index" do
  before(:each) do
    assign(:users, [
      stub_model(User,
        :account => "Account",
        :notify_email => "Notify Email",
        :refresh_token => "Refresh Token",
        :auth_token => "Auth Token",
        :notify_count => 111,
        :suspended => false,
        :check_target => "default"
      ),
      stub_model(User,
        :account => "Account",
        :notify_email => "Notify Email",
        :refresh_token => "Refresh Token",
        :auth_token => "Auth Token",
        :notify_count => 111,
        :suspended => false,
        :check_target => "default"
      )
    ])
  end

  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 111.to_s, :count => 2
    assert_select "tr>td", :text => "default".to_s, :count => 2
  end
end
