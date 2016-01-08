module Nearmiss
  class Client

    # Methods for the Incidents API
    #
    module Incidents

      # List nearmiss incidents
      #
      # @return [Array<Sawyer::Resource>] List of incidents
      #
      def incidents(options = {})
        since = options[:since] || options["since"]
        
        options.merge!(since: iso8601(parse_date(since))) if since
        
        paginate "incidents", options
      end
      alias :list_incidents :incidents
      alias :list_nearmisses :incidents
      alias :nearmisses :incidents


      # Get a single incident
      #
      # @param incident [String] ID of incident to fetch
      # @return [Sawyer::Resource] Incident information
      #
      def incident(incident, options = {})
        get "incidents/#{incident}", options
      end
      alias :nearmiss :incident

      # Create an incident
      #
      # @param options [Hash] Incident information.
      # @option options [String] :title Name of incident
      # @option options [String] :note Description of what happened
      # @option options [String] :category_id ID of associated category
      # @option options [String] :project_id ID of the project where the incident occured
      # @option options [String] :company Which company did the incident
      # @option options [String] :date When did the nearmiss occur
      # @option options [String] :trade e.g. is actually the activity
      # @option options [Boolean] :is_public Submit the nearmiss publically or private 
      #
      # @option options [String] :bad_weather "rainy", "sunny", "cloudy", "windy"
      # @option options [String] :injured Answers: "yes", "no"
      # @option options [String] :jha Answers: "yes", "no"
      # @option options [String] :messy Answers: "yes", "no"
      #
      # @option options [Array] :attachments
      #
      # @return [Sawyer::Resource] Newly created incident info
      def create_incident(options = {})
        post 'incidents', options
      end
      alias :create_nearmiss :create_incident

      def update_incident(incident, options = {})
        patch "incidents/#{incident}", options
      end
      alias :edit_incident :update_incident
      alias :update_nearmiss :update_incident
      alias :edit_nearmiss :update_incident

      # List incident comments
      #
      # @param incident_id [String] Incident Id.
      # @return [Array<Sawyer::Resource>] Array of hashes representing comments.
      # @example
      #   Nearmiss.incident_comments('3528ae645')
      def incident_comments(incident_id, options = {})
        paginate "incidents/#{incident_id}/comments", options
      end
      alias :nearmiss_comments :incident_comments

      # Get incident comment
      #
      # @param incident_id [String] Id of the incident.
      # @param comment_id [Integer] Id of the incident comment.
      # @return [Sawyer::Resource] Hash representing incident comment.
      # @example
      #   Nearmiss.incident_comment('208sdaz3', 1451398)
      def incident_comment(incident_id, comment_id, options = {})
        get "incidents/#{incident_id}/comments/#{comment_id}", options
      end
      alias :nearmiss_comment :incident_comment

      # Create incident comment
      #
      # @param incident_id [String] Id of the incident.
      # @param comment [String] Comment contents.
      # @return [Sawyer::Resource] Hash representing incident comment.
      # @example
      #   Nearmiss.incident_comment('208sdaz3', "Some text")
      def create_incident_comment(incident_id, comment, options = {})
        options.merge!({text: comment})
        post "incidents/#{incident_id}/comments", options
      end
      alias :create_nearmiss_comment :create_incident_comment

      # Update incident comment
      #
      # @param incident_id [String] Id of the incident.
      # @param comment_id [String] Id of the comment.
      # @param comment [String] Comment contents.
      # @return [Sawyer::Resource] Hash representing incident comment.
      # @example
      #   Nearmiss.incident_comment('208sdaz3', "Some text")
      def update_incident_comment(incident_id, comment_id, comment, options = {})
        options.merge!({text: comment})
        patch "incidents/#{incident_id}/comments/#{comment_id}", options
      end
      alias :edit_incident_comment :update_incident_comment
      alias :update_nearmiss_comment :update_incident_comment
      alias :edit_nearmiss_comment :update_incident_comment

      # Delete incident comment
      #
      # Requires authenticated client.
      #
      # @param incident_id [String] Id of the incident.
      # @param comment_id [Integer] Id of the comment to delete.
      # @return [Boolean] True if comment deleted, false otherwise.
      # @example
      #   @client.delete_incident_comment('208sdaz3', '586399')
      def delete_incident_comment(incident_id, comment_id, options = {})
        boolean_from_response(:delete, "incidents/#{incident_id}/comments/#{comment_id}", options)
      end
      alias :delete_nearmiss_comment :delete_incident_comment

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
