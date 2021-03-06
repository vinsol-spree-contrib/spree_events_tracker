module Spree
  class PageEvent < Spree::Base
    ACTIVITIES = { view: :view, search: :search, filter: :filter, index: :index }

    with_options polymorphic: true do
      belongs_to :actor
      belongs_to :target
    end

    validates :activity,
              :session_id, presence: true

    scope :viewed, -> { where(activity: :view) }
    scope :product, -> { where(target_type: 'Spree::Product') }

  end
end
