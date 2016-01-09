module Nearmiss

  # Class to parse GitHub repository owner and name from
  # URLs and to generate URLs
  class Project
    attr_accessor :owner, :name, :id

    # Instantiate from a GitHub repository URL
    #
    # @return [Repository]
    def self.from_url(url)
      Project.new(URI.parse(url).path[1..-1])
    end


    def initialize(project)
      case project
      # when Integer
      #   @id = project
      when String
        @id = project
        # @owner, @name = repo.split('/')
        # unless @owner && @name
        #   raise ArgumentError, "Invalid Repository. Use user/repo format."
        # end
      when Project
        @id   = project.id
        # @name = repo.name
      when Hash
        @id = project[:project] ||= project[:id]
        # @owner = repo[:owner] ||= repo[:user] ||= repo[:username]
      end
    end

    # Project owner/name
    # @return [String]
    def slug
      # "#{@owner}/#{@name}"
    end
    alias :to_s :slug

    # @return [String] Project API path
    def path
      # return named_api_path if @owner && @name
      return id_api_path if @id
    end

    # Get the api path for a repo
    # @param project [Integer, String, Hash, Project] A project.
    # @return [String] Api path.
    def self.path(project)
      new(project).path
    end

    # @return [String] Api path for owner/name identified repos
    # def named_api_path
    #   "repos/#{slug}"
    # end

    # @return [String] Api path for id identified repos
    def id_api_path
      "projects/#{@id}"
    end

    # Project URL based on {Nearmiss::Client#web_endpoint}
    # @return [String]
    def url
      # "#{Octokit.web_endpoint}#{slug}"
    end

    # alias :user :owner
    # alias :username :owner
    # alias :repo :name
  end
end
