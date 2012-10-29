require 'spec_helper'

describe "welcome/login_failed.html.erb" do

  it "render login failed screen" do
    render
    assert_select %Q{a[href="/sign_in"]}, true
  end
end
