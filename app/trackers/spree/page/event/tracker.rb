module Spree
  module Page::Event
    class Tracker < Spree::Event::Tracker
      EVENTS = { show: :view, search: :search, filter: :filter, index: :index }

      def initialize(arguments = {})
        super(arguments)
        @search_keywords = arguments[:search_keywords]
        @query_string = arguments[:query_string]
      end

      def track
        PageEvent.create(instance_values)
      end
    end
  end
end
