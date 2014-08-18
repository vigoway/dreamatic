require'digest'
class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    @user = User.find_by_id(session[:remember_token])
      respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  #displays the page of current user or the user being viewed
  def show
    @currentUser= User.find_by_id(session[:remember_token])
    @dreamlist = Dream.all
    @likeList = Like.all
    @requestlist = Array.new
    @requestlist = Request.find_all_by_target_id(@currentUser.id)
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/new
  # GET /users/new.json 
  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end
  
  
  # validates parameters of a new signup form and stores the user in the table
  # a user must have a name, email, password and optionally a picture
  def create
    @user = User.new(params[:user])
    if not_sensitive(params[:user][:name]) #1 if - start
      if verify_recaptcha(request.remote_ip, params)[:status] == 'false' #2 if - start
        @notice = "captcha incorrect"
        respond_to do |format|
          format.html { render :action => "new" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      else  #2 if - else: captcha right, go on 
        if @user.save! #3 if -start 
          @pic = Pic.new(:user_id => @user.id, :url => "../images/default.gif" )
          @pic.save!
          redirect_to :controller => 'sessions', :action => 'new'
        else #3 if - else: user is not saved in the db for some reason, explore why
          if User.find_by_email(@user.email) != nil 
            flash.now[:error1]= "*User email already exists."
          end
          if @user.name == nil or @user.email == nil or @user.password == nil or @user.password_confirmation == nil
            flash.now[:error2]= "*Info not correct! Make sure you your filled up all the info."
          end
          if @user.password_confirmation != @user.password
           flash.now[:error3]= "*Password and confirmation don't match."
          end
          if @user.check == 0
            flash.now[:error3]= "*You need to agree to the Website's policies to register."
          end
          render'new'  
        end #3 end
      end #2 end
    else #1 else
      flash.now[:error3]= "*Please don't use names that could cause confusion :P sorry."
      render'new' 
    end #1 end
  end # action end
     
  #filters usernames that should be used in a username
  def not_sensitive(myString)
    if ["Admin","admin","Administrator","ADMIN","ADMINISTRATOR"].include? myString
      false
    else
      true
    end
  end
   
  # fires a request to the server to change password 
  def change_password
    @user = User.find_by_id(session[:remember_token])
  end
    
    
  # Change user passowrd
  def change_password_update
    @user = User.find_by_id(session[:remember_token])
    @password = params[:password][:password]
    #check to see if the input for new password is blank
    if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
      @user.update_attributes(:password => params[:password], :password_confirmation => params[:password_confirmation])
      if @user.save
        flash.now[:error] = "password changed"
        redirect_to :controller => 'home', :action => 'loggedin'  
      else
        flash.now[:error] = "password not changed due to an unknown error"
        render :action => 'change_password'
      end
    else
      flash.now[:error] = "New Password mismatch" 
      render :action => 'change_password'
    end
  end
   

  #Updates user info based on input (scaffolding)
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /users/1
  # DELETE /users/1.json
  # deletes a user, by first deleting data (dreams, comments etc.) associated with the user
  def destroy
    @user = User.find(params[:id])
    if !@user.dreams.nil?
      @user.dreams.each do |d|
        d.destroy
      end
    end
    
    if !@user.friends.nil?
      @user.friends.each do |f|
        f.destroy
      end
    end
    
    if !@user.requests.nil?
      @user.requests.each do |r|
        r.destroy
      end
    end
    
    if !Request.find_all_by_target_id(@user.id).nil?
      Request.find_all_by_target_id(@user.id).each do |t|
        t.destroy
      end
    end
    
    @user.comments.all.each do |c|
      c.destroy
    end
    
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end

  # adds a pic to the user's profile
  def addpic
    @user = User.find_by_id(session[:remember_token]) 
    @photo = params[:user][:pic]
    if @user.pic != @photo
      @user.update_attributes(:pic => @photo)
      render 'home/loggedin'
    end
  end
  
  def admin
    @users = User.all
  end

end
