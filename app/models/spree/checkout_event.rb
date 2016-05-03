module Spree
  class CheckoutEvent < Spree::Base

    belongs_to :actor, polymorphic: true
    belongs_to :target, polymorphic: true

    validates :activity,
              :session_id,
              :target, presence: true
  end
end
