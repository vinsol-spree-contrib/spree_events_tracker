require 'logger'

module Spree
  class ArchiveDataService

    def initialize
      @events = [Spree::CartEvent, Spree::CheckoutEvent, Spree::PageEvent]
    end

    def perform
      @events.each do |event|
        archive_data(event, get_archived_event(event))
      end
    end

    def get_archived_event(event)
      "Spree::Archived#{event.to_s.demodulize}".constantize
    end

    def archive_data(event, archived_event)
      event.where("created_at < ?", 1.minute.ago).find_each do |record|
        archived_record = archived_event.new(record.attributes)
        if archived_record.save
          Rails.logger.info "#{event} #{record.id} archived"
          record.delete
        else
          Rails.logger.info "#{event} #{record.id} could not be archived"
        end
      end
    end

  end
end
