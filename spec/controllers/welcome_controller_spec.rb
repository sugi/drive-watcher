require 'spec_helper'

describe WelcomeController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'login_failed'" do
    it "returns http success" do
      get 'login_failed'
      response.should be_success
    end
  end

end
