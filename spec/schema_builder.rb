require "active_record"

# Spec schema builder
# Responsible for setting up and tearing down test database
# Used over database cleaner gem for simplicity and conflicts with most recent rails versions
class SchemaBuilder
  class << self
    def build
      drop_and_create
      setup_table
    end

    def truncate
      connection.execute("TRUNCATE TABLE tbl_users RESTART IDENTITY")
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

      connection.drop_database("test_seq_scanner")
      connection.create_database("test_seq_scanner")

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
      connection.create_table :tbl_users, id: :uuid do |table|
        table.string :name
        table.string :email
      end

      connection.add_index :tbl_users, :email
    end

    def connection
      ActiveRecord::Base.connection
    end
  end
end