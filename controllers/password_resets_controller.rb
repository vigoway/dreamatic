class PasswordResetsController < ApplicationController
  def new
  end

  # if a user forgot their password, send reset info to their email 
  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    flash[:notice] = "Email sent with password reset instructions."
    render 'new' 
  end

  #user comes back through the link sent by the action above
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  #updates the user's password at their request
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    #the user has to change their password within 2 hours after receiving the reset info
    if @user.password_reset_sent_at < 2.hours.ago 
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end


  
end
