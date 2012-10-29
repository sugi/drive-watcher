class ApplicationController < ActionController::Base
  class MyResponder < ActionController::Responder
    include Responders::FlashResponder
  end
  protect_from_forgery
  respond_to :html, :xml, :json
  self.responder = MyResponder
end
