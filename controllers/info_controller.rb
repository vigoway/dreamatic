require 'open-uri'
require 'pp'
class InfoController < ApplicationController
  def index 
    @info = Info.new
  end

  #leaves a msg to the site manager (has to be a user and pass captcha)
  def create
    @user = User.find_by_id(session[:remember_token])
    if(@user.nil?)
      flash.now[:error]= "*Please register first."
      render 'index'
    end
    @info = Info.new(params[:info]) 
    if verify_recaptcha(request.remote_ip, params)[:status] == 'false'
      @notice = "captcha incorrect"
      respond_to do |format|
        format.html { render :action => "index" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    else
      @name = @user.name
      @email = @user.email
      @comment = @info.comment
      UserMailer.comments_email(@name,@email,@comment).deliver
    end
  end

end
