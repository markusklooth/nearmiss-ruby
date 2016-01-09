module Nearmiss
  class Client

    # Methods for the Companies API
    #
    module Companies

      # List companies
      #
      # @note Shows a list of companies for the users organization aka account
      #
      # @return [Array<Sawyer::Resource>] List of companys
      def companies(options = {})
        paginate "companies", options
      end
      alias :list_companies :companies

      # Get a single company
      #
      # @param company [String] UUID of company to fetch
      # @return [Sawyer::Resource] Project information
      #
      def company(company, options = {})
        get "#{company_path(company)}", options
      end

      # Create a company
      #
      # @param options [Hash] Project information.
      # @option options [String] :name e.g. Berkeley Art Museum
      # @option options [String] :company_id e.g. 10611.70
      # @return [Sawyer::Resource] Newly created company info
      def create_company(options = {})
        post 'companies', options
      end

      # Edit a company
      #
      # @param options [Hash] Project information.
      # @option options [String] :name e.g. Berkeley Art Museum
      # @option options [String] :company_id e.g. 10611.70
      #
      # @return
      #   [Sawyer::Resource] Newly created company info
      # @example Update a company
      #   @client.edit_company('some_id', {
      #     name: "New name of company",
      #     company_id: "1043.32"
      #   })
      #
      def edit_company(company, options = {})
        patch "#{company_path(company)}", options
      end

      # Delete a company
      #
      # @param company [String] Project ID
      # @return [Boolean] Indicating success of deletion
      #
      def delete_company(company, options = {})
        boolean_from_response :delete, "companies/#{company}", options
      end
      alias :remove_company :delete_company

      private

      def company_path(id)
        if uuid?(id)
          "companies/#{id}"
        else
          "company/#{id}"
        end
      end
    end
  end
end
