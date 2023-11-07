require "active_record"

class SchemaBuilder
  class << self
    def build
      drop_and_create
      setup_table
    end

    def truncate
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE tbl_users RESTART IDENTITY")
    end

    private

    def drop_and_create
      ActiveRecord::Base.establish_connection(
        adapter: "postgresql",
        # database: "test_seq_scanner",
        username: "postgres",
        host: "localhost",
        port: 5432
      )

      ActiveRecord::Base.connection.drop_database("test_seq_scanner")
      ActiveRecord::Base.connection.create_database("test_seq_scanner")

      ActiveRecord::Base.establish_connection(
        adapter: "postgresql",
        database: "test_seq_scanner",
        username: "postgres",
        host: "localhost",
        port: 5432
      )
    end

    def setup_table
      ## Create tbl_users table with uuid id and name and email columns
      ActiveRecord::Base.connection.create_table :tbl_users, id: :uuid do |t|
        t.string :name
        t.string :email
      end

      ActiveRecord::Base.connection.add_index :tbl_users, :email
    end
  end
end