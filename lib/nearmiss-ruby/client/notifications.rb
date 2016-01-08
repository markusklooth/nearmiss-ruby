module Nearmiss
  class Client

    # Methods for the Notifications API
    #
    module Notifications

      # List notifications for the current user
      #
      # If user is not supplied, repositories for the current
      #   authenticated user are returned.
      #
      # @note If the user provided is a GitHub organization, only the
      #   organization's public repositories will be listed. For retrieving
      #   organization repositories the {Organizations#organization_repositories}
      #   method should be used instead.
      # @see https://developer.github.com/v3/repos/#list-your-repositories
      # @see https://developer.github.com/v3/repos/#list-user-repositories
      # @param user [Integer, String] Optional GitHub user login or id for which
      #   to list repos.
      # @return [Array<Sawyer::Resource>] List of projects
      def notifications(options = {})
        paginate "notifications", options
      end
      alias :list_notifications :notifications



    end
  end
end
