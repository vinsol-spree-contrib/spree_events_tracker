require 'spec_helper'

RSpec.describe Spree::ArchiveDataService, type: :service do

  let(:service) { Spree::ArchiveDataService.new }

  describe '#initialize' do
    it 'is expected to create a new instance of tagged logging' do
      expect(ActiveSupport::TaggedLogging).to receive(:new)
    end

    it 'is expected to initialize @archival_logger to logger instance' do
      expect(service.instance_variable_get(:@archival_logger).class).to eq(Logger)
    end

    after { Spree::ArchiveDataService.new }
  end

  describe '#get_log_file' do
    it 'is expected to return a new log file' do
      expect(service.get_log_file.class).to eq(Logger)
    end
  end

  describe '#perform' do
    it 'is expected to call archive_cart_events_data' do
      expect(service).to receive(:archive_cart_events_data)
    end

    it 'is expected to call archive_checkout_events_data' do
      expect(service).to receive(:archive_checkout_events_data)
    end

    it 'is expected to call archive_page_events_data' do
      expect(service).to receive(:archive_page_events_data)
    end

    after { service.perform }
  end

  describe '#archive_cart_events_data' do
    it 'is expected to call archive_data' do
      expect(service).to receive(:archive_data).with(Spree::CartEvent, Spree::ArchivedCartEvent)
    end

    after { service.archive_cart_events_data }
  end

  describe '#archive_checkout_events_data' do
    it 'is expected to call archive_data' do
      expect(service).to receive(:archive_data).with(Spree::CheckoutEvent, Spree::ArchivedCheckoutEvent)
    end

    after { service.archive_checkout_events_data }
  end

  describe '#archive_page_events_data' do
    it 'is expected to call archive_data' do
      expect(service).to receive(:archive_data).with(Spree::PageEvent, Spree::ArchivedPageEvent)
    end

    after { service.archive_page_events_data }
  end

  describe '#archive_data' do
    let!(:record) { Spree::PageEvent.create(activity: 'view', session_id: 'session_id', created_at: 1.year.ago) }
    let!(:archived_record) { Spree::ArchivedPageEvent.new(record.attributes.except('id')) }

    it 'is expected to call find_each on Spree::PageEvent' do
      expect(Spree::PageEvent).to receive(:find_each)
    end

    it 'is expected to build a new instance of Spree::ArchivedPageEvent' do
      expect(Spree::ArchivedPageEvent).to receive(:new).with(record.attributes.except('id'))
    end

    it 'is expected to call save! on archived_record' do
      expect_any_instance_of(Spree::ArchivedPageEvent).to receive(:save!)
    end

    it 'is expected to call delete on record' do
      expect_any_instance_of(Spree::PageEvent).to receive(:delete)
    end

    after { service.archive_data(Spree::PageEvent, Spree::ArchivedPageEvent) }
  end

end
