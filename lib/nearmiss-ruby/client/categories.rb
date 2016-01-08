module Nearmiss
  class Client

    # Methods for the Categories API
    #
    module Categories

      # List categories
      #
      # @return [Array<Sawyer::Resource>] List of categories
      def categories(options = {})
        paginate "categories", options
      end
      alias :list_categories :categories
      alias :list_cats :categories
      alias :cats :categories           

      # Get a single category
      #
      # @param category [String] ID of category to fetch
      # @return [Sawyer::Resource] Category information
      #
      def category(category, options={})
        get "categories/#{category}", options
      end
      alias :cat :category           


      # Create a category
      #
      # @param options [Hash] Category information.
      # @option options [String] :name e.g. Name of category
      # @return [Sawyer::Resource] Newly created category info
      def create_category(options = {})
        post 'categories', options
      end
      alias :create_cat :create_category

      # Edit a category
      #
      # @param options [Hash] Project information.
      # @option options [String] :name e.g. Tools
      #
      # @return
      #   [Sawyer::Resource] Edited category info
      # @example Update a category
      #   @client.edit_category('some_id', {
      #     name: "New name of category",
      #   })

      def edit_category(category, options = {})
        patch "categories/#{category}", options
      end
      alias :edit_cat :edit_category


      # Delete a category
      #
      # @param category [String] Project ID
      # @return [Boolean] Indicating success of deletion
      #
      def delete_category(category, options = {})
        boolean_from_response :delete, "categories/#{category}", options
      end
      alias :delete_cat :delete_category
      alias :remove_category :delete_category
      alias :remove_cat :delete_category


    end
  end
end
