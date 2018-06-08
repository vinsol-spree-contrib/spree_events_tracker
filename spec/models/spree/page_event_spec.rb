require 'spec_helper'

describe Spree::PageEvent do

  describe 'associations' do
    it { is_expected.to belong_to(:actor) }
    it { is_expected.to belong_to(:target) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:session_id) }
    it { is_expected.to validate_presence_of(:activity) }
  end

  describe 'constant' do
    it 'is expected to define ACTIVITIES' do
      expect(described_class::ACTIVITIES).to eq({ view: :view, search: :search, filter: :filter, index: :index })
    end
  end

end
