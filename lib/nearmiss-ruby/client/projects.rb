module Nearmiss
  class Client

    # Methods for the Projects API
    #
    module Projects

      # List projects
      #
      # @note Shows a list of projects for the users organization aka account
      #
      # @return [Array<Sawyer::Resource>] List of projects
      def projects(options = {})
        paginate "projects", options
      end
      alias :list_projects :projects

      # Get a single project
      #
      # @param project [String] UUID of project to fetch
      # @return [Sawyer::Resource] Project information
      #
      def project(project, options = {})
        get "#{project_path(project)}", options
      end

      # Create a project
      #
      # @param options [Hash] Project information.
      # @option options [String] :name e.g. Berkeley Art Museum
      # @option options [String] :project_id e.g. 10611.70
      # @return [Sawyer::Resource] Newly created project info
      def create_project(options = {})
        post 'projects', options
      end

      # Edit a project
      #
      # @param options [Hash] Project information.
      # @option options [String] :name e.g. Berkeley Art Museum
      # @option options [String] :project_id e.g. 10611.70
      #
      # @return
      #   [Sawyer::Resource] Newly created project info
      # @example Update a project
      #   @client.edit_project('some_id', {
      #     name: "New name of project",
      #     project_id: "1043.32"
      #   })
      #
      def edit_project(project, options = {})
        patch "#{project_path(project)}", options
      end

      # Delete a project
      #
      # @param project [String] Project ID
      # @return [Boolean] Indicating success of deletion
      #
      def delete_project(project, options = {})
        boolean_from_response :delete, "projects/#{project}", options
      end
      alias :remove_project :delete_project

      private

      def project_path(id)
        if uuid?(id)
          "projects/#{id}"
        else
          "project/#{id}"
        end
      end
    end
  end
end
