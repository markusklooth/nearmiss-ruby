module Nearmiss
  module Util
    def url_encode(hash)
      hash.to_a.map {|p| p.map {|e| CGI.escape get_string(e)}.join '='}.join '&'
    end

    def get_string(obj)
      if obj.respond_to?(:strftime)
        obj.strftime('%Y-%m-%d')
      else
        obj.to_s
      end
    end

    # Validate if argument is a UUID 
    #
    # @param uuid [String] the string to test against
    # @return [Boolean]
    # @example
    #   Nearmiss.uuid?("31817811-dce4-48c4-aa5f-f49603c5abee") => true
    #   Nearmiss.uuid?("test@gmail.com") => false
    #
    def uuid?(uuid)
      return true if uuid =~ /\A[\da-f]{32}\z/i
      return true if
        uuid =~ /\A(urn:uuid:)?[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}\z/i
      return false
    end


  end
end
