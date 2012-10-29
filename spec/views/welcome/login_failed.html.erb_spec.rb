require 'spec_helper'

describe "welcome/login_failed.html.erb" do
  assert_select %Q{a[:href="/sign_in"]}, true
end
