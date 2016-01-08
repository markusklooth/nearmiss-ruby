module Nearmiss
  class Client

    # Methods for the Users API
    #
    module Users

      # List users
      #
      # @note Logged in user must be an admin to see all users
      #
      # @return [Array<Sawyer::Resource>] List of projects
      def users(options = {})
        paginate "users", options
      end
      alias :list_users :users

      # Get a single user
      #
      # @param user [String] Nearmiss user email or id.
      # @return [Sawyer::Resource]
      # @example
      #   Nearmiss.user("31817811-dce4-48c4-aa5f-f49603c5abee") or Nearmiss.user("m4rkuskk+a@gmail.com")
      def user(user=nil, options = {})
        if user.nil?
          get "me", options
        else
          get "users/#{user}", options
        end
        # get User.path(user), options
      end

      # Edit a user
      #
      # @param options [Hash] User information.
      # @option options [String] :email Email of user
      # @option options [String] :name Name of user
      # @option options [String] :nickname Nickname of user
      # @option options [Integer] :role Set to admin or not
      # @option options [String] :phone_number Phone number of user
      # @option options [String] :image URL of image of user
      # @option options [String] :language Code "en", "de", "es"
      # @return
      #   [Sawyer::Resource] Edited user info
      # @example Update a user
      #   @client.edit_user('some_id', {
      #     email: "mklooth@webcor.com",
      #     name: "Markus Klooth"
      #   })
      #
      def edit_user(user, options = {})
        patch "update_user/#{user}", options
      end
      alias :update_user :edit_user

      def update_email(user, options = {})

      end


      def delete_user(user, options = {})
        delete "users/#{user}", options
      end

      # Validate user username and password
      #
      # @param options [Hash] User credentials
      # @option options [String] :email Nearmiss login email
      # @option options [String] :password Nearmiss password
      # @return [Boolean] True if credentials are valid
      def validate_credentials(options = {})
        !self.class.new(options).user.nil?
      rescue Nearmiss::Unauthorized
        false
      end



    end
  end
end
