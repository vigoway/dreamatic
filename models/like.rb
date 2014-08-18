class Like < ActiveRecord::Base
set_table_name "likes"
belongs_to :user
belongs_to :dream

end
