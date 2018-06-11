require 'logger'

module Spree
  class ArchiveDataService

    def initialize
      @archival_logger ||= ActiveSupport::TaggedLogging.new(Logger.new("#{Rails.root}/log/data_archival.log"))
    end

    def perform
      archive_data(Spree::CartEvent, Spree::ArchivedCartEvent)
      archive_data(Spree::CheckoutEvent, Spree::ArchivedCheckoutEvent)
      archive_data(Spree::PageEvent, Spree::ArchivedPageEvent)
    end

    def archive_data(event, archived_event)
      event.find_each do |record|
        archived_record = archived_event.new(record.attributes)
        @archival_logger.tagged(event) { @archival_logger.info "Archival started at #{Time.current}" }

        ActiveRecord::Base.transaction do
          @archival_logger.tagged(event) { @archival_logger.info "Started archiving #{record.id}" }
          begin
            archived_record.save!
            record.destroy!
            @archival_logger.tagged(event) { @archival_logger.info "#{record.id} archived" }
          rescue => e
            @archival_logger.tagged(event) { @archival_logger.info "Error: #{e}" }
            @archival_logger.tagged(event) { @archival_logger.info "#{record.id} could not be archived" }
            raise ActiveRecord::Rollback
          end
        end
        @archival_logger.tagged(event) { @archival_logger.info "Archival stopped at #{Time.current}" }
      end
    end

  end
end
