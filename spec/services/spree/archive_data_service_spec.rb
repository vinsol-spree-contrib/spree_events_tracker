require 'spec_helper'

RSpec.describe Spree::ArchiveDataService, type: :service do

  let(:service) { Spree::ArchiveDataService.new }

  describe '#initialize' do
    it 'is expected to initialize @archival_logger to logger instance' do
      expect(service.instance_variable_get(:@archival_logger).class).to eq(Logger)
    end
  end

  describe '#perform' do
    before do
      allow(service).to receive(:archive_data).with(Spree::CartEvent, Spree::ArchivedCartEvent)
      allow(service).to receive(:archive_data).with(Spree::PageEvent, Spree::ArchivedPageEvent)
      allow(service).to receive(:archive_data).with(Spree::CheckoutEvent, Spree::ArchivedCheckoutEvent)
    end

    it 'is expected to call archive data on Spree::CartEvent' do
      expect(service).to receive(:archive_data).with(Spree::CartEvent, Spree::ArchivedCartEvent)
    end

    it 'is expected to call archive data on Spree::PageEvent' do
      expect(service).to receive(:archive_data).with(Spree::PageEvent, Spree::ArchivedPageEvent)
    end

    it 'is expected to call archive data on Spree::CheckoutEvent' do
      expect(service).to receive(:archive_data).with(Spree::CheckoutEvent, Spree::ArchivedCheckoutEvent)
    end

    after { service.perform }
  end

  describe '#archive_data' do
    let!(:record) { Spree::PageEvent.create(activity: 'view', session_id: 'session_id', created_at: 1.year.ago) }
    let!(:archived_record) { Spree::ArchivedPageEvent.new(record.attributes) }

    before do
      allow(service).to receive(:event).and_return(Spree::PageEvent)
      allow(service).to receive(:archived_event).and_return(Spree::ArchivedPageEvent)
      allow(Spree::ArchivedPageEvent).to receive(:new).and_return(archived_record)
    end

    it 'is expected to call save on archived_record' do
      expect(archived_record).to receive(:save!)
    end

    context 'when record is archived' do
      before do
        allow(archived_record).to receive(:save!).and_return(true)
      end

      it 'is expected to destroy the record' do
        expect_any_instance_of(Spree::PageEvent).to receive(:destroy!)
      end
    end

    context 'when record is not archived' do
      before do
        allow(archived_record).to receive(:save!).and_raise(ActiveRecord::RecordNotSaved)
      end

      it 'is not expected to destroy the record' do
        expect_any_instance_of(Spree::PageEvent).not_to receive(:destroy!)
      end
    end

    after { service.archive_data(Spree::PageEvent, Spree::ArchivedPageEvent) }
  end

end
