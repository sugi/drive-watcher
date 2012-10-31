require "spec_helper"

describe UserMailer do

  describe "notify_unread" do
    let(:mail) {
      user = User.create(:account => TEST_USER_UID, :notify_email => 'to@example.org')
      user.instance_variable_set :@_updated_files, [
	{ "title" => "title text",
	  "modifiedDate" => DateTime.now,
	  "lastModifyingUserName" => "modbyname",
	  "alternateLink" => "http://drive.google/test", },
      ]
      UserMailer.notify_unread(user)
    }

    it "renders the headers" do
      mail.subject.should eq(I18n.t "user_mailer.notify_unread.subject")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq([Rails.configuration.mail_from])
    end

    it "renders the body" do
      mail.body.encoded.should match("modbyname")
      mail.body.encoded.should match("title text")
      mail.body.encoded.should match("http://drive.google/test")
    end
  end

end
