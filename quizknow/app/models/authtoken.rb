require 'oauth/consumer'

class Authtoken < ActiveRecord::Base

  CONSUMER = OAuth::Consumer.new(
    IKNOW_OAUTH_KEY,
    IKNOW_OAUTH_SECRET,
    :site => "http://#{IKNOW_API_HOST_WITH_PORT}",
    :authorize_url => "http://#{IKNOW_HOST_WITH_PORT}/oauth/authorize")
    
  def self.new_request_token
    begin
      CONSUMER.get_request_token
    rescue Exception => e
      nil
    end
  end

  def self.establish_auth_token(iknow_username, request_token)

    access_token = request_token.get_access_token

    at = Authtoken.new
    at.username = iknow_username
    at.token = access_token.token
    at.secret = access_token.secret
    at.save!
  end

  def to_access_token
    OAuth::AccessToken.new(CONSUMER, self.token, self.secret)
  end
end

