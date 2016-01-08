module Nearmiss
  class Client

    # Methods for the Bookmarks API
    #
    module Bookmarks

      # List bookmarks
      #
      # @return [Array<Sawyer::Resource>] List of bookmarks
      def bookmarks(options = {})
        paginate "bookmarks", options
      end
      alias :list_bookmarks :bookmarks

      # Get a single bookmark
      #
      # @param bookmark [String] ID of bookmark to fetch
      # @return [Sawyer::Resource] Bookmark information
      #
      def bookmark(bookmark, options={})
        get "bookmarks/#{bookmark}", options
      end

      # Delete a bookmark
      #
      # @param bookmark_id [String] Id of the bookmark.
      # @return [Boolean] True if bookmark deleted, false otherwise.
      # @example
      #   @client.delete_bookmark('208sdaz3')
      #
      def delete_bookmark(bookmark_id, options={})
        boolean_from_response(:delete, "bookmarks/#{bookmark_id}", options)

      end

    end
  end
end
