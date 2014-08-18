class RequestsController < ApplicationController
  def new
  @user = User.find_by_id(session[:remember_token])
  @request = Request.new(:user_id => @user.id, :target_id => params[:id])
  @request.save!
  redirect_to(:back)
  flash.now[:notice] = "Request has been sent" 
  end
  
  def clear
  @req = Request.all
  @req.each do |d|
  d.destroy
  end
  redirect_to '/users'
  end
  
  def respond
  @requests = Request.find_all_by_target_id(params[:id])
  end
  
  def cancel
  @user = User.find(session[:remember_token])
  @request = @user.requests.find_by_target_id(params[:id])
  @request.destroy
  redirect_to(:back)
  rescue ActionController::RedirectBackError
  redirect_to :action => :show, :controller => :users, :id => params[:id]
  end
  
  def destroy
  @request = Request.find_by_id(params[:id])
  @request.destroy
  redirect_to(:back)
  end
  
end
