require 'spec_helper'

describe Spree::Admin::EventsTrackerSettingsController, type: :controller do

  describe 'GET #edit' do
    stub_authorization!
    before { get :edit }
    it { is_expected.to render_template :edit }
  end

  describe 'PATCH #update' do
    stub_authorization!

    before do
      Spree::Config.events_tracker_archive_data = false
      patch :update, params: { events_tracker_archive_data: true }
    end

    it 'is expected to save the updated value of events_tracker_archive_data' do
      expect(Spree::Config.events_tracker_archive_data).to eq(true)
    end

    it { is_expected.to set_flash[:success].to(Spree.t(:successfully_updated, resource: Spree.t(:events_tracker_settings))) }

    it { is_expected.to redirect_to(edit_admin_events_tracker_setting_path) }
  end

end
