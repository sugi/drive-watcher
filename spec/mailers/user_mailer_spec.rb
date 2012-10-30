require "spec_helper"

describe UserMailer do
  describe "notify_unread" do
    let(:mail) { UserMailer.notify_unread }

    it "renders the headers" do
      mail.subject.should eq("Notify unread")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
