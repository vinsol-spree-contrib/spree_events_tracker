Spree::Core::Engine.add_routes do
  namespace :admin do
    resource :events_tracker_setting, only: [:edit, :update]
  end
end
