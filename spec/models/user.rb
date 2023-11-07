require 'active_record'

class User < ActiveRecord::Base
  self.table_name = 'tbl_users'
end