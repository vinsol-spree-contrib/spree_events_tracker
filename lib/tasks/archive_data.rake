namespace :spree_events_tracker do
  desc "archive data from primary tables to archived tables"

  task archive_data: :environment do |t, args|
    if Spree::Config.events_tracker_archive_data
      Spree::ArchiveDataService.new.perform
    end
  end
end
