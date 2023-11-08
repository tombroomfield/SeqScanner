require_relative '../plan_formatter'
require 'paint'

module SeqScanner
  # Formatted error that is raised when a sequential scan is detected
  class SeqScanDetectedError < StandardError
    def initialize(query_plan, **opts)
      formatter = opts.fetch(:formatter) { PlanFormatter }
      

      super(formatter.new(query_plan).format_error_message)
    end
  end
end
