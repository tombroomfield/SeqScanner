require 'active_record'

# Test user model
# Contains an UUID id, name and email columns
class User < ActiveRecord::Base
  self.table_name = 'tbl_users'
end