require_relative 'errors/seq_scan_detected_error'

module SeqScanner
  # Model representing a query plan
  class QueryPlan
    attr_reader :name, :sql, :binds, :query_plan

    def initialize(input, result)
      self.sql = input[:sql]
      self.name = input[:name]
      self.binds = input[:binds].map do |bind|
        {
          name: bind.name,
          value: bind.value,
        }
      end
      self.query_plan = result
    end

    def validate
      return true if schema_migrations?
      return true unless seq?

      raise SeqScanDetectedError.new(self)
    end

    private

    def schema_migrations?
      name == 'SCHEMA'
    end

    def seq?
      return true if query_plan.find do |line|
        line =~ /Seq Scan/
      end

      false
    end
    
    attr_writer :sql, :name, :binds, :query_plan
  end
end