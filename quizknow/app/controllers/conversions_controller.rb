require 'oauth/consumer'

class ConversionsController < ApplicationController
  
  def create
    authtoken = Authtoken.find_by_username(params[:conversion][:iknow_username])
    puts "Hello"
    unless authtoken
        puts "doing auth request"
      redirect_to(
        :controller => :oauth,
        :action => :new_request,
        :username => params[:conversion][:iknow_username])

    else

      puts params[:conversion].inspect

      @conversion = Conversion.new(params[:conversion])

      if @conversion.save
        redirect_to(conversions_url) and return
      end

      render(:action => :index)
    end
  end
end
