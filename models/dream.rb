require'digest'
class Dream < ActiveRecord::Base
set_table_name "dreams"
belongs_to :user
has_many :likes
has_many :comments

attr_accessible :user_id, :content, :rank, :created_at, :updated_at, :privacy, :type, :category, :resources, :state
validates :content, :presence => true, :length => {:maximum =>200}


end
