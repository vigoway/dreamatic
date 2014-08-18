require 'open-uri'
require 'pp'
class InfoController < ApplicationController
  def index 
      @info = Info.new
  end

  def create
  @user = User.find_by_id(session[:remember_token])
  if(@user.nil?)
    flash.now[:error]= "*Please register first."
    render 'index'
  end
   
     @info = Info.new(params[:info]) 
     
     
   #@answer = @info.name
   #open('http://captchator.com/captcha/check_answer/dreamatic/' + @answer) do |f|
   #pp f.meta
   #f.each do |line|
   #@key = line
   #end
   #end
   #if @key== '1' # returns true or false
   
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
