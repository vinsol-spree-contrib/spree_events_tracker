module Spree
  class ArchivedPageEvent < Spree::Base

    with_options polymorphic: true do
      belongs_to :actor, optional: true
      belongs_to :target
    end

    scope :viewed, -> { where(activity: :view) }
    scope :product, -> { where(target_type: 'Spree::Product') }
  end
end
