# frozen_string_literal: true

require_relative "seq_scanner/version"
require_relative "seq_scanner/switcher"
require_relative "seq_scanner/checker"
# require_relative "seq_scanner/errors/"

module SeqScanner
  class << self
    def scan(&block)
      transact do
        discourage_seqscan do
          validate &block
        end
      end
    end

    def discourage_seqscan
      SeqScanner::Switcher.on
      yield
    ensure
      SeqScanner::Switcher.off
    end

    private

    def transact
      # return yield
      return yield if ActiveRecord::Base.connection.transaction_open?
      ActiveRecord::Base.transaction { yield }
    end

    def validate(&block)
      Checker.new.check_query_plan(&block)
    end
  end
end