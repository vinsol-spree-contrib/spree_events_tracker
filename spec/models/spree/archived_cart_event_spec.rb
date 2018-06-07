require 'spec_helper'

describe Spree::ArchivedCartEvent do

  describe 'associations' do
    it { is_expected.to belong_to(:actor) }
    it { is_expected.to belong_to(:target) }
    it { is_expected.to belong_to(:variant) }
    it { is_expected.to have_one(:product).through(:variant) }
  end

end
