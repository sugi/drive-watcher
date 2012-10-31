require 'spec_helper'

describe "welcome/index.html.erb" do

  it "have login link" do
    # override default prepare method
    view.stub(:user_signed_in?).and_return(false)
    view.stub(:current_user).and_return(nil)
    render
    assert_select %Q{a[href="/sign_in"]}, true
  end
end
