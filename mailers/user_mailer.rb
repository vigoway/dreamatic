class UserMailer < ActionMailer::Base
  
default :from => "non-reply@dreamatic.org"

  def comments_email(name, email, comment)
  @name = name
  @email = email
  @comment = comment
  @url = "http://www.dreamatic.org"
  mail(:to =>"admin@dreamatic.org",:subject=>"Comments from #{@name}")
  end  
  
  def dreams_email(name, email, comment, dream)
  @name = name
  @email = email
  @comment = comment
  @dream = dream
  @url = "http://www.dreamatic.org"
  mail(:to =>@email, :subject=>"Comments from #{@name}")
  end  
 
  def password_reset(user)
  @user = user
  mail :to => user.email, :subject => "Password Reset"
  end


 
end
