class ApplicationController < ActionController::Base
  before_action :return_notification
  def hello
    render html: 'hello, world!'
  end
  include SessionsHelper
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  private

  def test?
    Rails.env.test?
  end

  # def basic_auth
  #   authenticate_or_request_with_http_basic do |username, password|
  #     username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
  #   end
  # end
end
