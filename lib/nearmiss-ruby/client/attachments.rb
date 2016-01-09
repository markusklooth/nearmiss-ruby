module Nearmiss
  class Client

    # Methods for the Attachments API
    #
    module Attachments

      # List nearmiss attachments
      #
      # @return [Array<Sawyer::Resource>] List of attachments
      #
      def attachments(options = {})
        since = options[:since] || options["since"]

        options.merge!(since: iso8601(parse_date(since))) if since

        paginate "attachments", options
      end
      alias :list_attachments :attachments

      # Get a single attachment
      #
      # @param attachment [String] ID of attachment to fetch
      # @return [Sawyer::Resource] Incident information
      #
      def attachment(attachment, options = {})
        get "attachments/#{attachment}", options
      end

      # Project attachments
      #
      # @param project [String, Hash, Incident] Incident
      # @return [Sawyer::Resource] Incident information
      #
      def incident_attachments(incident, options = {})

        paginate "#{Incident.new(incident).path}/attachments", options

      end
      alias :nearmiss_attachments :incident_attachments


      # Create an attachment
      #
      # @param options [Hash] Attachment information.
      # @option options [String] :created_by_id Id of person who created this attachment
      # @option options [String] :original_filename title of file
      # @option options [String] :content_type e.g. `image/jpeg`
      # @option options [String] :attachable_id associated ID of resource this attachment belongs to
      # @option options [String] :attachable_type e.g. Incident

      #
      # @return [Sawyer::Resource] Newly created attachment info
      def create_attachment(options = {})
        post 'attachments', options
      end


      def update_attachment(attachment, options = {})
        patch "attachments/#{attachment}", options
      end
      alias :edit_attachment :update_attachment


    protected

    def iso8601(date)
      if date.respond_to?(:iso8601)
        date.iso8601
      else
        date.strftime("%Y-%m-%dT%H:%M:%S%Z")
      end
    end
      # Parses the given string representation of a date, throwing a meaningful exception
      # (containing the date that failed to parse) in case of failure.
      #
      # @param date [String] String representation of a date
      # @return [DateTime]
      def parse_date(date)
        date = DateTime.parse(date.to_s)
      rescue ArgumentError
        raise ArgumentError, "#{date} is not a valid date"
      end


    end
  end
end
