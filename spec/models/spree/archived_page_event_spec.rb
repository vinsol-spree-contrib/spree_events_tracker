require 'spec_helper'

describe Spree::ArchivedPageEvent do

  let(:archived_page_event_view_activity) { Spree::ArchivedPageEvent.create(activity: :view) }
  let(:archived_page_event_search_activity) { Spree::ArchivedPageEvent.create(activity: :search) }
  let(:archived_page_event_target_product) { Spree::ArchivedPageEvent.create(target_type: 'Spree::Product') }
  let(:archived_page_event_target_taxon) { Spree::ArchivedPageEvent.create(target_type: 'Spree::Taxon') }

  describe 'associations' do
    it { is_expected.to belong_to(:actor) }
    it { is_expected.to belong_to(:target) }
  end

  describe 'scopes' do
    describe '.viewed' do
     it 'is expected to include events with view activity' do
       expect(Spree::ArchivedPageEvent.viewed).to include(archived_page_event_view_activity)
     end

     it 'is not expected to include events with non view activity' do
       expect(Spree::ArchivedPageEvent.viewed).not_to include(archived_page_event_search_activity)
     end
    end

    describe '.product' do
     it 'is expected to include events with target type product' do
       expect(Spree::ArchivedPageEvent.product).to include(archived_page_event_target_product)
     end

     it 'is not expected to include events with target type not product' do
       expect(Spree::ArchivedPageEvent.product).not_to include(archived_page_event_target_taxon)
     end
    end
  end


end
