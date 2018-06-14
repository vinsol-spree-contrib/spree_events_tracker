require 'spec_helper'

describe Spree::AppConfiguration, type: :model do

  it { expect(Spree::Config).to have_preference(:events_tracker_archive_data) }
  it { expect(Spree::Config.preferred_events_tracker_archive_data_type).to eq(:boolean) }
  it { expect(Spree::Config.preferred_events_tracker_archive_data_default).to eq(false) }

end
