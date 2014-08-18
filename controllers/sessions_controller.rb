class SessionsController < ApplicationController
  def new
  end

  def create
  user = User.authenticate(params[:session][:email], params[:session][:password])
  if user.nil?
    flash.now[:error] = "invalid emails/password combination"
    render 'new'
  else
      session[:remember_token] = user.id
    
    @user = User.find_by_id(session[:remember_token]) 
    if(@user.email=="admin@dreamatic.org") 
            redirect_to :controller => 'users', :action => 'index'
    elsif session[:url] == nil
      redirect_to :controller => :users, :action => :show, :id => user.id
     else
      redirect_to session[:url]
      session[:url] = nil
     end
    end    
  end

  
  def change
   end
   
   def change_password
   @user = User.find_by_id(session[:remember_token])
  if User.authenticate(@user.email, params[:password][:password]) == @user
    @user.update_attribute (:password, params[:password][:new_password])
    @user.update_attribute (:password_confirmation, params[:password][:new_password_confirmation])
    if @user.save
       redirect_to :controller => 'sessions', :action => 'new'
       flash.now[:error] = "Now, log in with your new password."
     else
       render 'change'
       flash.now[:error] = "An error occurred and password was not changed"
     end
   else
      flash.now[:error] = "old password could not be authenticated."
      render 'change'
    end
  
  end


  
  
  def destroy
    session[:remember_token] =nil
    session[:user]=nil
    session[:dream] =nil
    redirect_to :controller => 'home', :action => 'index'
  end
end
