require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :account => "Account",
      :name => "Name",
      :notify_email => "Notify Email",
      :refresh_token => "Refresh Token",
      :auth_token => "Auth Token",
      :error_count => 1,
      :suspended => false,
      :check_target => "default"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Account/)
    rendered.should match(/Name/)
    rendered.should match(/Notify Email/)
    rendered.should match(/Refresh Token/)
    rendered.should match(/Auth Token/)
    rendered.should match(/1/)
    rendered.should match(/false/)
    rendered.should match(/default/)
  end
end
