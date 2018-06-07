require 'spec_helper'

describe Spree::ArchivedPageEvent do

  describe 'associations' do
    it { is_expected.to belong_to(:actor) }
    it { is_expected.to belong_to(:target) }
  end

  describe 'constant' do
    it 'is expected to define ACTIVITIES' do
      expect(described_class::ACTIVITIES).to eq({ view: :view, search: :search, filter: :filter, index: :index })
    end
  end

end
