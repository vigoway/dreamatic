class HomeController < ApplicationController

  def index
   @dream = Dream.new
   @dreams = Array.new  
   @dreamlist = Array.new
   @likeList = Array.new
   @pics = Array.new
   @like = Like.new
   @user = User.new
   @pic = Pic.new
  end
 
  
  def ref_logo
   @user = User.find_by_id(session[:remember_token])
   if(@user.nil?)
   @user = User.new
   render 'index'
   else
   @dreams = @user.dreams 
   @dreamlist = Dream.all
   @likeList = Like.all
   redirect_to :controller => :users, :action => :show, :id =>@user.id
   end
  end


  def loggedin 
   @user = User.find_by_id(session[:remember_token]) 
   @dreams = @user.dreams.all   
   @dreamlist = Dream.all 
   @dreamlist.sort!{|a,b|b.id <=> a.id}
   @likeList = Like.all
   @userList = User.all
   if @user.pics.size != 0
   @pic = @user.pics[0]
   else
   @pic = Pic.new(:user_id => @user.id, :url => "../images/default.gif" )
   @pic.save!
   end
   if(@user.email == "admin@dreamatic.com")
  redirect_to :controller => 'users', :action => 'index'
   end
  end
 
  def admin
  @userList = User.all
  end
  
  def dreamList
    @user = User.find_by_id(session[:remember_token]) 
    @dreamlist = Dream.all
  @likeList = Like.all
  end
  
  def comingup
    @user = User.find_by_id(session[:remember_token]) 
    @userList = User.all
  end
  
  def like
  @dream = Dream.find(params[:id])
  @user = User.find_by_id(session[:remember_token]) 
  @likee = @dream.user_id
  @dream.rank +=1
  @like = Like.new(:user_id=>@user.id, :likee_id=>@likee, :dream_id=>params[:id])
  @like.save
  if(@dream.save! && @like.save)
   redirect_to :controller =>'dreams', :action=>'show', :id => @dream.id
  else
  flash.now[:error] = "illegal input!"
  end
  end
  
  def unlike
  @dream = Dream.find(params[:id])
  @user = User.find_by_id(session[:remember_token]) 
  @dream.rank -=1
  if(@dream.save!) 
  @like = @user.likes.find_by_dream_id(params[:id])
  @like.destroy
   redirect_to :controller =>'dreams', :action=>'show', :id => @dream.id
  else
  flash.now[:error] = "illegal input!"
  end
  end
  
  def addpic
  @user = User.find_by_id(session[:remember_token]) 
  if(@user.pics.size != 0)
  @user.pics[0].destroy
  end
  @pic = Pic.new(:user_id => @user.id, :url => params[:pic][:url])
  @pic.save!
  redirect_to(:back)
  end
  

  
  def comment
  @user = User.find_by_id(session[:remember_token]) 
  @dream =  Dream.find_by_id(params[:id])
  @c = params[:comment]
  @answer = @c.key
  open('http://captchator.com/captcha/check_answer/dreamatic/' + @answer) do |f|
   pp f.meta
   f.each do |line|
   @key = line
   end
  end
  if @key== '1' # returns true or false
  @comment = Comment.new(:user_id => @user.id, :dream_id => @dream.id, :content => @c.content)
  if @comment.save!
    redirect_to 'home/dreamList'
  else
    flash.now[:error] = "Comment was not posted due to an unknown error, please try again later or contact dreamatic.com."
    render 'new'
  end
  else
    flash.now[:error] = "Check your verification number."
    redirect_to 'home/loggedin'
  end
  end

  
  def policies
  end
  
  def standards
  end
  

  def signup
    @user = User.new(params[:user])
    if @user.save
      redirect_to :controller => 'sessions', :action => 'new'
    else
      render'index'
      flash.now[:error]= "Sign up failure, please try again."
    end
  end

end
