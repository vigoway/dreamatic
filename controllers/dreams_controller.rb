class DreamsController < ApplicationController
  attr_accessor :id
  
  def index
    @dream = Dream.new
      respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @dreams }
      end
  end
  
  #show the specific dream
  def show
    @dreamlist = Dream.all
    @likeList = Like.all
    @dream = Dream.find_by_id(params[:id])
    if @dream.state != nil
    @time = @dream.created_at + (@dream.state).to_i.days
    end
    @user = User.find_by_id(session[:remember_token]) 
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @dream }
    end
  end

  #loads the pages with a form to add a dream 
  def new
    @dream = Dream.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @dream }
    end
  end

  def edit
    @dream = Dream.find(params[:id])
  end

  #store a dream into the db. A dream has user_id(FK), user_name, content, rank(#likes), privacy(boolean)
  def create
    @user = User.find_by_id(session[:remember_token]) 
    @p = params[:dream][:privacy]
    if @p == 'false'
      @privacy = false    
    else
      @privacy = true     #private, dream not visible to others
    end
      @dream = Dream.new(:name => @user.name, :user_id => @user.id, :content => params[:dream][:content], :rank => 0, :privacy => @privacy, :category=>params[:dream][:category], :resources => params[:dream][:resources], :state => params[:dream][:state])
    
    #responds based on whether save was successful
    if @dream.save
       redirect_to :action=>'show', :id=> @dream.id
       flash.now[:notice] = "Dream posted"
    else 
       render 'index'
       flash.now[:error] = "Unexpected Error"
    end
  end
 
  #method for the view that shows dreams from all users
  def dreamList
    @user = User.find_by_id(session[:remember_token]) 
    @dreamlist = Dream.all
  end
  
  #handles the logic when a user clicks on the like button. 
  def like
    @dream = Dream.find(params[:id])
    @user = User.find_by_id(session[:remember_token])
    @likee = @dream.user_id
    @dream.rank +=1
    #record the like to 1. update the like btn to unlike btn, & 2. prevent repeated votes
    @like = Like.new(:user_id=>@user.id, :likee_id=>@likee, :dream_id=>params[:id])
    @like.save
    if(@dream.save! && @like.save)
     redirect_to :action=>'show', :id => @dream.id
    else
      flash.now[:error] = "illegal input!"
    end
  end
  
  #handles unliking a dream by the user
  def unlike
    @dream = Dream.find(params[:id])
    @user = User.find_by_id(session[:remember_token])
    @dream.rank -=1
    if(@dream.save!)
      @like = @user.likes.find_by_dream_id(params[:id])
      @like.destroy
      redirect_to :action=>'show'
    else
      flash.now[:error] = "illegal input!"
    end
  end

  #updates the dream based on user input
  def update
    @dream = Dream.find(params[:id])

    respond_to do |format|
      if @dream.update_attributes(params[:dream])
        format.html { redirect_to @dream, :notice => 'Dream was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @dream.errors, :status => :unprocessable_entity }
      end
    end
  end

  #deletes a dream (recursively deletes its likes and comments first)
  def destroy
    @dream = Dream.find(params[:id])
    likes = @dream.likes.all
    likes.each do |l|
      l.destroy
    end
    comments = @dream.comments.all
    comments.each do |c|
      c.destroy
    end
    @dream.destroy
    redirect_to(:back)  #redirects to the previous page
  end

end
