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
 # GET /users/1
  # GET /users/1.json
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
  

  def create
  @user = User.new(params[:user])
  if not_sensitive(params[:user][:name])
  if verify_recaptcha(request.remote_ip, params)[:status] == 'false'
      @notice = "captcha incorrect"
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    else
    if @user.save!
         @pic = Pic.new(:user_id => @user.id, :url => "../images/default.gif" )
         @pic.save!
      redirect_to :controller => 'sessions', :action => 'new'
      else 
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
    end
    end
    else
    flash.now[:error3]= "*Please don't use names that could cause confusion :P sorry."
    render'new' 
  end
  
  end
     
     def not_sensitive(myString)
     
       if ["Admin","admin","Administrator","ADMIN","ADMINISTRATOR","Vigo","VIGO","Yucheng", "YUCHENG", "Vigo Wei"].include? myString
           false
         else
           true
         end
      end
   
   def change_password
   @user = User.find_by_id(session[:remember_token])
    end
    
    
    #
    # Change user passowrd
    def change_password_update
    @user = User.find_by_id(session[:remember_token])
    @password = params[:password][:password]
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
