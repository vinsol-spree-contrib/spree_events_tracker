require 'logger'

module Spree
  class ArchiveDataService

    def initialize
      @archival_logger ||= ActiveSupport::TaggedLogging.new(get_log_file)
    end

    def get_log_file
      Logger.new(Rails.root.join('log', 'data_archival.log'))
    end

    def perform
      archive_cart_events_data
      archive_checkout_events_data
      archive_page_events_data
    end

    def archive_cart_events_data
      @archival_logger.tagged('Spree::CartEvent') { @archival_logger.info "Archival started at #{Time.current}" }
      archive_data(Spree::CartEvent, Spree::ArchivedCartEvent)
      @archival_logger.tagged('Spree::CartEvent') { @archival_logger.info "Archival stopped at #{Time.current}" }
    end

    def archive_checkout_events_data
      @archival_logger.tagged('Spree::CheckoutEvent') { @archival_logger.info "Archival started at #{Time.current}" }
      archive_data(Spree::CheckoutEvent, Spree::ArchivedCheckoutEvent)
      @archival_logger.tagged('Spree::CheckoutEvent') { @archival_logger.info "Archival stopped at #{Time.current}" }
    end

    def archive_page_events_data
      @archival_logger.tagged('Spree::PageEvent') { @archival_logger.info "Archival started at #{Time.current}" }
      archive_data(Spree::PageEvent, Spree::ArchivedPageEvent)
      @archival_logger.tagged('Spree::PageEvent') { @archival_logger.info "Archival stopped at #{Time.current}" }
    end

    def archive_data(event, archived_event)
      event.find_each do |record|
        archived_record = archived_event.new(record.attributes.except('id'))

        ActiveRecord::Base.transaction do
          @archival_logger.tagged(event) { @archival_logger.info "Started archiving #{record.id}" }
          begin
            archived_record.save!
            record.delete
            @archival_logger.tagged(event) { @archival_logger.info "#{record.id} archived" }
          rescue => e
            @archival_logger.tagged(event) { @archival_logger.info "#{record.id} could not be archived. Error: #{e}" }
            raise ActiveRecord::Rollback
          end
        end

      end
    end

  end
end
