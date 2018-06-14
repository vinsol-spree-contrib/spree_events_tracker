require 'spec_helper'

describe Spree::ArchivedCartEvent do

  let(:archived_cart_event_add_activity) { Spree::ArchivedCartEvent.create(activity: 'add') }
  let(:archived_cart_event_remove_activity) { Spree::ArchivedCartEvent.create(activity: 'remove') }
  let(:archived_cart_event_update_activity) { Spree::ArchivedCartEvent.create(activity: 'update') }

  describe 'associations' do
    it { is_expected.to belong_to(:actor) }
    it { is_expected.to belong_to(:target) }
    it { is_expected.to belong_to(:variant) }
    it { is_expected.to have_one(:product).through(:variant) }
  end

  describe 'scopes' do
    describe '.added' do
      it 'is expected to contain events with add activity' do
        expect(Spree::ArchivedCartEvent.added).to include(archived_cart_event_add_activity)
      end

      it 'is not expected to contain events without add activity' do
        expect(Spree::ArchivedCartEvent.added).not_to include(archived_cart_event_remove_activity)
      end
    end

    describe '.removed' do
      it 'is expected to contain events with remove activity' do
        expect(Spree::ArchivedCartEvent.removed).to include(archived_cart_event_remove_activity)
      end

      it 'is not expected to contain events without remove activity' do
        expect(Spree::ArchivedCartEvent.removed).not_to include(archived_cart_event_update_activity)
      end
    end

    describe '.updated' do
      it 'is expected to contain events with update activity' do
        expect(Spree::ArchivedCartEvent.updated).to include(archived_cart_event_update_activity)
      end

      it 'is not expected to contain events without update activity' do
        expect(Spree::ArchivedCartEvent.updated).not_to include(archived_cart_event_add_activity)
      end
    end

  end

end
