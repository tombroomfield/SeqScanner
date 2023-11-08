require_relative 'query_explainer'
require_relative 'query_plan'

module SeqScanner
  # Listens to the sql.active_record events then re-runs the queries with EXPLAIN
  # Calls #validate on any query plans that are returned
  class Checker
    def initialize(**opts)
      self.queries = []
      self.explainer = opts.fetch(:explainer) { QueryExplainer }
    end

    def check_query_plan(&block)
      subscribe
      result = block.call
      unsubscribe

      execute_query_plans.each(&:validate)

      result
    end

    private

    def execute_query_plans
      queries.map do |query|
        QueryPlan.new(query, explainer.explain(query))
      end
    end

    def subscribe
      self.subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |_, _, _, _, details|
        queries << details
      end
    end

    def unsubscribe
      ActiveSupport::Notifications.unsubscribe(subscriber)
      self.subscriber = nil
    end

    attr_accessor :queries, :query_plans, :explainer, :validator, :subscriber
  end
end