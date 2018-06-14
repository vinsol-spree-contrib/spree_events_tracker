require 'spec_helper'

describe 'rake spree_events_tracker:archive_data', type: :task do

  context 'when archival data preference is true' do
    before do
      allow(Spree::ArchiveDataService).to receive(:new).and_call_original
      Spree::Config.events_tracker_archive_data = true
    end

    it 'is expected to create instance of data archival service' do
      expect(Spree::ArchiveDataService).to receive(:new)
    end

    it 'is expected to call perform on instance of archival service' do
      expect_any_instance_of(Spree::ArchiveDataService).to receive(:perform)
    end

    after { task.execute }
  end

  context 'when archival data preference is false' do
    before do
      Spree::Config.events_tracker_archive_data = false
    end

    it 'is not expected to create instance of data archival service' do
      expect(Spree::ArchiveDataService).not_to receive(:new)
    end

    after { task.execute }
  end

end
