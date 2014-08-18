class FriendsController < ApplicationController
  def add
  @request = Request.find_by_id(params[:request])
  @friend = Friend.new(:user_id => session[:remember_token].to_i, :friend_id => @request.user_id)
  @friend.save!
  @friend2 = Friend.new(:user_id => @request.user_id, :friend_id =>session[:remember_token].to_i)
  @friend2.save!
  @request.destroy
  redirect_to(:back)
  end

  def remove
  @user = User.find_by_id(session[:remember_token])
  @friend = @user.friends.find_by_friend_id(params[:id])
  @friend.destroy
  @friend2 = User.find_by_id(params[:id]).friends.find_by_friend_id(@user.id)
  @friend2.destroy
  redirect_to(:back)
  end

  def destroy
  @friend2 = User.find_by_id(@friend.friend_id).friends.find_by_friend_id(@friend.user_id)
  @friend2.destroy
  @friend.destroy
  end
  
  
end
