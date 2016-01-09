module Nearmiss

  # Class to parse incident owner and name from
  # URLs and to generate URLs
  class Incident
    attr_accessor :id

    # Instantiate from a incident URL
    #
    # @return [Incident]
    def self.from_url(url)
      Incident.new(URI.parse(url).path[1..-1])
    end


    def initialize(incident)
      case incident
      # when Integer
      #   @id = incident
      when String
        @id = incident
        # @owner, @name = repo.split('/')
        # unless @owner && @name
        #   raise ArgumentError, "Invalid Incident. Use user/repo format."
        # end
      when Incident
        @id   = incident.id
        # @name = repo.name
      when Hash
        @id = incident[:incident] ||= incident[:id]
        # @owner = repo[:owner] ||= repo[:user] ||= repo[:username]
      end
    end

    # Incident owner/name
    # @return [String]
    def slug
      # "#{@owner}/#{@name}"
    end
    alias :to_s :slug

    # @return [String] Incident API path
    def path
      # return named_api_path if @owner && @name
      return id_api_path if @id
    end

    # Get the api path for a repo
    # @param incident [Integer, String, Hash, Incident] A incident.
    # @return [String] Api path.
    def self.path(incident)
      new(incident).path
    end

    # @return [String] Api path for owner/name identified repos
    # def named_api_path
    #   "repos/#{slug}"
    # end

    # @return [String] Api path for id identified incidents
    def id_api_path
      "incidents/#{@id}"
    end

    # Incident URL based on {Nearmiss::Client#web_endpoint}
    # @return [String]
    # def url
    #   "#{Octokit.web_endpoint}#{slug}"
    # end

    # alias :user :owner
    # alias :username :owner
    # alias :repo :name
  end
end
