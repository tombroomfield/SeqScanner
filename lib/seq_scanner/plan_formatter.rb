require 'paint'
module SeqScanner
  module PlanFormatter
    class << self
      def format(query_plan)
        query_plan.map do |line|
          if line =~ /Seq Scan/
            Paint[line, :red]
          else
            Paint[line, :white]
          end
        end.join("\n")
      end
    end
  end
end