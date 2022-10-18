class ApplicationController < ActionController::Base
  before_action :basic_auth if Rails.env.test?
  def hello
    render html: 'hello, world!'
  end
  include SessionsHelper

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end
end
