module Spree
  class CartEvent < Spree::Base

    with_options polymorphic: true do
      belongs_to :actor
      belongs_to :target
    end
    belongs_to :variant

    validates :activity,
              :actor,
              :quantity,
              :target,
              :total,
              :variant, presence: true

    scope :added,   -> { where(activity: 'add')    }
    scope :removed, -> { where(activity: 'remove') }
    scope :updated, -> { where(activity: 'update') }
  end
end
