require 'spec_helper'

describe 'rake spree_events_tracker:set_archival_choice', type: :task do

  before { task.execute }

  it 'is expected to set data archival preference to true' do
    expect(Spree::Config.events_tracker_archive_data).to eq(true)
  end

end
