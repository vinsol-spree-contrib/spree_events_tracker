module Spree
  class ArchivedPageEvent < Spree::Base
    ACTIVITIES = { view: :view, search: :search, filter: :filter, index: :index }

    with_options polymorphic: true, optional: true do
      belongs_to :actor
      belongs_to :target
    end

  end
end
