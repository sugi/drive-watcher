require 'spec_helper'

describe User do
  def valid_attributes
    {
      :account => 'google-acount@google.com',
    }
  end

  it "user admin flag" do
    orig_admin = Rails.configuration.admin_users
    Rails.configuration.admin_users = %w(should-not-matched@gmail.com)
    user = User.create! valid_attributes
    user.should_not be_admin

    Rails.configuration.admin_users = [valid_attributes[:account]]
    user.should be_admin
    Rails.configuration.admin_users = orig_admin
  end
end
