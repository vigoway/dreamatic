class CommentsController < ApplicationController
  def index
    @user = User.find_by_id(session[:remember_token]) 
    @comment = Comment.new
  end

  #adding a comment to a dream
  def new
    if(session[:dream] == nil)
      session[:dream] = params[:id]
    end
    @dream = Dream.find_by_id(session[:dream])
  end
  
  #show the dream the user selected
  def find_dream
    if session[:dream] == nil
      session[:dream] = Dream.new
    session[:dream]
    end
  end
  
  #stores a comment in the table, a comment has a user_id(FK), dream_id(FK), and content
  def create
    @user = User.find_by_id(session[:remember_token]) 
    @dream = Dream.find_by_id(params[:id])
    @comment = Comment.new(:user_id => @user.id, :dream_id => @dream.id, :content => params[:c][:content].to_s)
    #if comment is saved, notify the user whose dream received this comment
    if @comment.save!
      @email = @dream.user.email
      @name = @user.name
      @comment = params[:c][:content].to_s
      UserMailer.dreams_email(@name,@email,@comment,@dream).deliver
      redirect_to :controller=>'dreams', :action=>'show', :id =>@dream.id
    #show error msg if comment failed to save
    else
      flash.now[:error] = "Comment was not posted due to an unknown error, please try again later or contact dreamatic.com."
      render 'new'
    end
  end
  
  #deletes a comment
  def delete
    @comment = Comment.find(params[:id])
    @comment.destroy
    render 'users'
   end
end
