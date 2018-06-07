module Spree
  class ArchivedCheckoutEvent < Spree::Base

    with_options polymorphic: true, optional: true do
      belongs_to :actor
      belongs_to :target
    end

  end
end
