class Comment < ActiveRecord::Base
set_table_name "comments"
attr_accessible :user_id, :dream_id, :content
belongs_to :user
belongs_to :dream

validates :content, :presence => true, :length => {:maximum =>200}
end
