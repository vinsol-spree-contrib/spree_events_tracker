module Spree
  class ArchivedPageEvent < Spree::Base

    with_options polymorphic: true do
      belongs_to :actor, optional: true
      belongs_to :target
    end

  end
end
