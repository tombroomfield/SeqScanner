# frozen_string_literal: true
require_relative "models/user"


describe SeqScanner do
  context 'When we run a query that would never use an index' do
    let(:query) { User.order(:id).take }
    it 'should not raise an error' do
      expect { SeqScanner.scan { query } }.not_to raise_error
    end
  end

  context 'When we run a query that should use an index' do
    let(:query) { User.order(:name).take }

    context 'And the index is not present' do
      it 'should raise an error' do
        expect { SeqScanner.scan { query } }.to raise_error(SeqScanner::SeqScanDetectedError)
      end

      it 'should raise an error message with the query' do
        expect { SeqScanner.scan { query } }.to raise_error(SeqScanner::SeqScanDetectedError, /ORDER BY/)
      end

      it 'should raise an error message with the table name' do
        expect { SeqScanner.scan { query } }.to raise_error(SeqScanner::SeqScanDetectedError, /tbl_users/)
      end

      it 'should raise an error message with the query plan' do
        expect { SeqScanner.scan { query } }.to raise_error(SeqScanner::SeqScanDetectedError, /Seq Scan/)
      end

      it 'should raise an error message with the bindings' do
        expect { SeqScanner.scan { query } }.to raise_error(SeqScanner::SeqScanDetectedError, /\$1/)
      end
    end

    context 'And the index is present' do
      before { ActiveRecord::Base.connection.add_index :tbl_users, :name }

      it 'should not raise an error' do
        expect { SeqScanner.scan { query } }.not_to raise_error
      end
    end
  end
end
