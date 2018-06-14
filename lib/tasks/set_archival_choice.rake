namespace :spree_events_tracker do
  desc "set data archival preference to true"

  task set_archival_choice: :environment do |t, args|
    Spree::Config.events_tracker_archive_data = true
    puts 'Done!'
  end
end
