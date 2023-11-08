require 'paint'
module SeqScanner
  # Formats the query plan for display in the error message
  class PlanFormatter
    def initialize(query_plan)
      self.query_plan = query_plan
    end

    def format_error_message
      self.class.format(
        name: query_plan.name,
        sql: query_plan.sql,
        binds: query_plan.binds,
        query_plan: query_plan.query_plan)
    end

    private

    class << self
      def format(**opts)
        name = opts.fetch(:name)
        sql = opts.fetch(:sql)
        binds = opts.fetch(:binds)
        query_plan = opts.fetch(:query_plan)
        
        <<~ERROR
          #{default("Sequential scan detected in query plan for the #{emphasis(name)} query:")}
          
          #{format_query_section(sql)}

          #{format_plan_section(query_plan)}

          #{format_bindings_section(binds)}
        ERROR
      end

      private

      def format_query_section(sql)
        <<~ERROR
          #{default("Query:")}
          #{default(sql)}
        ERROR
      end

      def format_plan_section(query_plan)
        <<~ERROR
          #{default("Query plan:")}
          #{format_lines(query_plan)}
        ERROR
      end

      def format_bindings_section(binds)
        <<~ERROR
          #{default("Bindings")}
          #{binds.map { |bind| default("#{bind[:name]}: #{bind[:value]}") }.join("\n")}
        ERROR
      end

      def format_lines(lines)
        lines.map do |line|
          line =~ /Seq Scan/ ? error(line) : default(line)
        end.join("\n")
      end

      def default(text)
        Paint[text, :white]
      end

      def emphasis(text)
        Paint[text, :yellow]
      end

      def error(text)
        Paint[text, :red]
      end
    end

    private 

    attr_accessor :query_plan
  end
end