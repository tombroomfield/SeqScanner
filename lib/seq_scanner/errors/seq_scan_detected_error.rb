require_relative '../plan_formatter'
require 'paint'

module SeqScanner
  class SeqScanDetectedError < StandardError
    def initialize(query_plan)
      msg = <<~ERROR
        #{white("Sequential scan detected in query plan for the #{yellow(query_plan.name)} query:")}
        
        #{white("Query:")}
        #{white(query_plan.sql)}

        #{white("Query plan:")}
        #{PlanFormatter.format(query_plan.query_plan)}

        #{white("Bindings")}
        #{query_plan.binds.map { |bind| white("#{bind[:name]}: #{bind[:value]}") }.join("\n")}
      ERROR
      super(msg)
    end

    private

    def white(text)
      Paint[text, :white]
    end

    def yellow(text)
      Paint[text, :yellow]
    end
  end
end
