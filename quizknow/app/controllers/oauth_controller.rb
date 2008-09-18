
class OauthController < ApplicationController

  # no auth token found, request a request token and let the user validate
  # it on iKnow! site
  #
  def new_request

    @request_token = Authtoken.new_request_token

    session[:username] = params[:username]
    session[:request_token] = @request_token
    
    if @request_token
      redirect_to(@request_token.authorize_url)
    else
      render(:text => "Failed to get a Request Token") 
    end

  end

  # request token just got validated by user, establish the auth token
  # (and redirect to conversion/new)
  #
  def callback

    puts "storing auth token #{session[:username]}"
    Authtoken.establish_auth_token(session[:username], session[:request_token])

    redirect_to(conversions_url)

    # TODO : redirect to conversion/new
  end
end
