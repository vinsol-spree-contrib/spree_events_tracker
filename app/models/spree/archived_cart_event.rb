module Spree
  class ArchivedCartEvent < Spree::Base

    with_options polymorphic: true, optional: true do
      belongs_to :actor
      belongs_to :target
    end

    belongs_to :variant
    has_one :product, through: :variant

  end
end
