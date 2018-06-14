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
    let(:order) { create(:completed_order_with_totals) }
    let(:line_item) { order.line_items.first }
    let(:variant) { line_item.variant }

    let!(:cart_event_1) { Spree::CartEvent.create(actor: order, target: line_item, activity: 'add', quantity: line_item.quantity, total: order.total, variant: variant) }
    let!(:cart_event_2) { Spree::CartEvent.create(actor: order, target: line_item, activity: 'remove', quantity: line_item.quantity, total: order.total, variant: variant) }

    it 'is expected to call archive_data' do
      expect(service).to receive(:archive_data).with(Spree::CartEvent, Spree::ArchivedCartEvent)
      service.archive_cart_events_data
    end

    context 'archive cart events' do
      it 'is expected to create archived cart event records' do
        expect { service.archive_cart_events_data }.to change { Spree::ArchivedCartEvent.count }.from(0).to(2)
      end

      it 'is expected to create archived records with data same as those of original records' do
        service.archive_cart_events_data
        expect(cart_event_1.attributes.except(:id)).to eq(Spree::ArchivedCartEvent.first.attributes.except(:id))
      end

      it 'is expected to delete cart event records' do
        expect { service.archive_cart_events_data }.to change { Spree::CartEvent.count }.from(2).to(0)
      end
    end
  end

  describe '#archive_checkout_events_data' do
    let(:user) { create(:user) }
    let(:order) { create(:completed_order_with_totals) }

    let!(:checkout_event_1) { Spree::CheckoutEvent.create(actor: user, target: order, activity: 'initialize_order', previous_state: "cart", next_state: "address", session_id: "wferfegre") }
    let!(:checkout_event_2) { Spree::CheckoutEvent.create(actor: user, target: order, activity: 'change_order_state', previous_state: "address", next_state: "delivery", session_id: "wferfegre") }

    it 'is expected to call archive_data' do
      expect(service).to receive(:archive_data).with(Spree::CheckoutEvent, Spree::ArchivedCheckoutEvent)
      service.archive_checkout_events_data
    end

    context 'archive checkout events' do
      it 'is expected to create archived checkout event records' do
        expect { service.archive_checkout_events_data }.to change { Spree::ArchivedCheckoutEvent.count }.from(0).to(2)
      end

      it 'is expected to create archived records with data same as those of original records' do
        service.archive_checkout_events_data
        expect(checkout_event_1.attributes.except(:id)).to eq(Spree::ArchivedCheckoutEvent.first.attributes.except(:id))
      end

      it 'is expected to delete checkout event records' do
        expect { service.archive_checkout_events_data }.to change { Spree::CheckoutEvent.count }.from(2).to(0)
      end
    end
  end

  describe '#archive_page_events_data' do
    let(:user) { create(:user) }
    let(:product) { create(:product) }

    let!(:page_event_1) { Spree::PageEvent.create(actor: user, activity: 'index', session_id: "wferfegre") }
    let!(:page_event_2) { Spree::PageEvent.create(actor: user, target: product, activity: 'show', session_id: "wferfegre") }

    it 'is expected to call archive_data' do
      expect(service).to receive(:archive_data).with(Spree::PageEvent, Spree::ArchivedPageEvent)
      service.archive_page_events_data
    end

    context 'archive page events' do
      it 'is expected to create archived page event records' do
        expect { service.archive_page_events_data }.to change { Spree::ArchivedPageEvent.count }.from(0).to(2)
      end

      it 'is expected to create archived records with data same as those of original records' do
        service.archive_page_events_data
        expect(page_event_1.attributes.except(:id)).to eq(Spree::ArchivedPageEvent.first.attributes.except(:id))
      end

      it 'is expected to delete cart event records' do
        expect { service.archive_page_events_data }.to change { Spree::PageEvent.count }.from(2).to(0)
      end
    end
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
