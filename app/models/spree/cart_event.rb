module Spree
  class CartEvent < Spree::Base

    belongs_to :actor, polymorphic: true
    belongs_to :target, polymorphic: true
    belongs_to :variant

    validates :activity,
              :actor,
              :quantity,
              :target,
              :total,
              :variant, presence: true
  end
end
