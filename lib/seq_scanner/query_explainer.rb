module SeqScanner
  # Runs EXPLAIN on queries that have been executed
  module QueryExplainer
    class << self
      def explain(query)
        return false if query[:name] == "SCHEMA"
        connection.unprepared_statement do
          connection.exec_query("EXPLAIN #{query[:sql]}", 'SQL', query[:binds]).to_a.map do |row|
            row['QUERY PLAN']
          end
        end
      end

      private

      def connection
        ActiveRecord::Base.connection
      end
    end
  end
end