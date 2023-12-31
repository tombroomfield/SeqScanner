module SeqScanner
  # Abstracts the switching of the enable_seqscan flag
  module Switcher
    class << self
      def on
        ActiveRecord::Base.connection.execute("SET LOCAL enable_seqscan = on")
      end

      def off
        ActiveRecord::Base.connection.execute("SET LOCAL enable_seqscan = off")
      end
    end
  end
end