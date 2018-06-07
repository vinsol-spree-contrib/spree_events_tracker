class Spree::Admin::EventsTrackerSettingsController < Spree::Admin::BaseController

  def update
    Spree::Config.events_tracker_archive_data = params[:events_tracker_archive_data]

    flash[:success] = Spree.t(:successfully_updated, resource: Spree.t(:events_tracker_settings))
    redirect_to edit_admin_events_tracker_setting_path
  end
end
