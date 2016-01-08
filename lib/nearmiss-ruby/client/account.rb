module Nearmiss
  class Client

    # Methods for the Bookmarks API
    #
    module Account

      def account(options = {})
        get "account", options
      end

    end
  end
end
