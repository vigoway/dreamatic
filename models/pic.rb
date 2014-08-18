class Pic < ActiveRecord::Base
set_table_name "pics"
belongs_to :user
attr_accessible :user_id, :url

end
