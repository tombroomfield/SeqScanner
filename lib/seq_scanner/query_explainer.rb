module SeqScanner
  module QueryExplainer
    class << self
      def explain(query)
        return false if query[:name] == "SCHEMA"
        ActiveRecord::Base.connection.unprepared_statement do
          ActiveRecord::Base.connection.exec_query("EXPLAIN #{query[:sql]}", 'SQL', query[:binds]).to_a.map do |row|
            row['QUERY PLAN']
          end
        end
      end
    end
  end
end