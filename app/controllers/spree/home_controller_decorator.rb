Spree::HomeController.class_eval do
  include Spree::PageTracker
  track_actions [:index]
end
