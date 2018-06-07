Spree::AppConfiguration.class_eval do
  preference :events_tracker_archive_data, :boolean, default: false
end
