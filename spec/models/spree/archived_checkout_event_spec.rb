require 'spec_helper'

describe Spree::ArchivedCheckoutEvent do

  describe 'associations' do
    it { is_expected.to belong_to(:actor) }
    it { is_expected.to belong_to(:target) }
  end

end
