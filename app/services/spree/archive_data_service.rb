require 'logger'

module Spree
  class ArchiveDataService

    def perform
      archive_data(Spree::CartEvent, Spree::ArchivedCartEvent)
      archive_data(Spree::CheckoutEvent, Spree::ArchivedCheckoutEvent)
      archive_data(Spree::PageEvent, Spree::ArchivedPageEvent)
    end

    def archive_data(event, archived_event)
      event.find_each do |record|
        archived_record = archived_event.new(record.attributes)

        ActiveRecord::Base.transaction do
          if archived_record.save
            record.delete
            Rails.logger.info "#{event} #{record.id} archived"
          else
            Rails.logger.info "#{event} #{record.id} could not be archived"
            Rails.logger.info "#{archived_record.errors.full_messages}"
          end
        end

      end
    end

  end
end
