module Spree
  module OrderContentsWithTracker

    # Override: since order's line_items were overridden
    def update_cart(params)
      if order.update_attributes(filter_order_items(params))
        order.line_items.each do |line_item|
          if line_item.previous_changes.keys.include?('quantity')
            Spree::Cart::Event::Tracker.new(
              actor: order, target: line_item, total: order.total, variant_id: line_item.variant_id
            ).track
          end
        end
        # line_items which have 0 quantity will be lost and couldn't be tracked
        # so tracking is done before the execution of next statement
        order.line_items = order.line_items.select { |li| li.quantity > 0 }
        persist_totals
        PromotionHandler::Cart.new(order).activate
        order.ensure_updated_shipments
        persist_totals
        true
      else
        false
      end
    end

    def remove_line_item(line_item, options = {})
      # In Cart Event Tracker, we use DirtyObject's previous_changes method.
      # Following statement handles the case, when we delete a line_item from order's cart page (from back_end)
      line_item.update(quantity: 0)
      super
    end

    def remove_from_line_item(variant, quantity, options = {})
      line_item = grab_line_item_by_variant(variant, true, options)
      line_item.quantity -= quantity
      line_item.target_shipment= options[:shipment]

      if line_item.quantity.zero?
        # In Cart Event Tracker, we use DirtyObject's previous_changes method.
        # Following statement handles the case, when we delete a line_item from order's shipments page (from back_end)
        line_item.update(quantity: 0)
        order.line_items.destroy(line_item)
      else
        line_item.save!
      end

      line_item
    end

    private

    # Override: Add tracking entry after a line_item is added or removed
    def after_add_or_remove(line_item, options = {})
      line_item = super
      Spree::Cart::Event::Tracker.new(
        actor: order, target: line_item, total: order.total, variant_id: line_item.variant_id
      ).track
      line_item
    end
  end
end

Spree::OrderContents.send(:prepend, Spree::OrderContentsWithTracker)
