require 'spec_helper'

describe "Users" do
  describe "GET /users" do
    it "redirect to login" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get users_path
      response.status.should be(302)
    end
  end
end
