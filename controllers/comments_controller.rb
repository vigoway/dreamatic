class CommentsController < ApplicationController
  def index
  @user = User.find_by_id(session[:remember_token]) 
  @comment = Comment.new
  end

  def new
  if(session[:dream] == nil)
    session[:dream] = params[:id]
  end
  @dream = Dream.find_by_id(session[:dream])
  end
  
  def find_dream
  if session[:dream] == nil
    session[:dream] = Dream.new
  session[:dream]
  end
  end
  
  def create
  @user = User.find_by_id(session[:remember_token]) 
  @dream = Dream.find_by_id(params[:id])
  # @answer = params[:c][:answer].to_s
  # open('http://captchator.com/captcha/check_answer/dreamatic/' + @answer) do |f|
   # pp f.meta
   # f.each do |line|
   # @key = line
   # end
  # end
  # if @key== '1' # returns true or false
    @comment = Comment.new(:user_id => @user.id, :dream_id => @dream.id, :content => params[:c][:content].to_s)
    if @comment.save!
      @email = @dream.user.email
      @name = @user.name
      @comment = params[:c][:content].to_s
      UserMailer.dreams_email(@name,@email,@comment,@dream).deliver
      redirect_to :controller=>'dreams', :action=>'show', :id =>@dream.id
    else
      flash.now[:error] = "Comment was not posted due to an unknown error, please try again later or contact dreamatic.com."
      render 'new'
    end
  # else
    # flash.now[:error] = "Check your verification number."
    # redirect_to 'home/loggedin'
  # end
  end
  
  def delete
  @comment = Comment.find(params[:id])
    @comment.destroy
    render 'users'
   end
end
