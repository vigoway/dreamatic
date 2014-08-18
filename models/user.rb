require'digest'
class User < ActiveRecord::Base
set_table_name "users"
has_many :dreams, :dependent => :destroy
has_many :likes
has_many :pics
has_many :comments
has_many :friends
has_many :requests


attr_accessible :name, :email, :check, :pic, :photo

  validates :name, :presence => true, :length => {:maximum =>50}
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, :format => {:with => email_regex},:uniqueness => {:case_sensitive => false}
  validates_numericality_of :check, :greater_than => 0, :less_than => 2, :message => "must be agreed"
  attr_accessor :password #this creates the virtual attribute password
  attr_accessible :name, :email, :password, :password_confirmation
  validates :password, :presence => true, :confirmation => true, :length => {:within => 6..40}

  before_save :encrypt_password

  def encrypt_password
    self.encrypted_password = encrypt(password)
  end
  def encrypt
    string
  end

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def encrypt_password
    self.salt = make_salt unless has_password?(password)
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
 end

def send_password_reset
  generate_token(:password_reset_token)
  self.password_reset_sent_at = Time.zone.now
  save!(:validate => false)
  UserMailer.password_reset(self).deliver
end

  
def generate_token(column)
  begin
    self[column] = SecureRandom.hex
  end while User.exists?(column => self[column])
end


end
