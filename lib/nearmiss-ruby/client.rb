# require "set"
require "nearmiss-ruby/authentication"
require "nearmiss-ruby/configurable"
require "nearmiss-ruby/arguments"
require "nearmiss-ruby/util"
require "nearmiss-ruby/rate_limit"
require "nearmiss-ruby/project"
require "nearmiss-ruby/incident"

require "nearmiss-ruby/client/account"
require "nearmiss-ruby/client/bookmarks"
require "nearmiss-ruby/client/categories"
require "nearmiss-ruby/client/incidents"
require "nearmiss-ruby/client/notifications"
require "nearmiss-ruby/client/projects"
require "nearmiss-ruby/client/rate_limit"
require "nearmiss-ruby/client/users"
require "nearmiss-ruby/client/companies"
require "nearmiss-ruby/client/attachments"


module Nearmiss

  class Client
    include Nearmiss::Util
    include Nearmiss::Authentication
    include Nearmiss::Configurable

    include Nearmiss::Client::Account
    include Nearmiss::Client::Bookmarks
    include Nearmiss::Client::Categories
    include Nearmiss::Client::Incidents
    include Nearmiss::Client::Notifications
    include Nearmiss::Client::Projects
    include Nearmiss::Client::RateLimit
    include Nearmiss::Client::Users
    include Nearmiss::Client::Companies
    include Nearmiss::Client::Attachments

    # include Nearmiss::Client::Users
    # include Nearmiss::Client::ProjectLibrary
    # include Nearmiss::Client::Projects
    # include Nearmiss::Client::Templates
    # include Nearmiss::Client::Checklists
    # include Nearmiss::Client::Tasks
    # include Nearmiss::Client::Issues
    # include Nearmiss::Client::Utils

    attr_accessor :access_token, :client_id, :uid, :expiry, :me

    CONVENIENCE_HEADERS = Set.new([:accept, :content_type])


    def initialize(options = {})

      # Use options passed in, but fall back to module defaults
      Nearmiss::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Nearmiss.instance_variable_get(:"@#{key}"))
      end

      sign_in if basic_authenticated?
    end

    # Compares client options to a Hash of requested options
    #
    # @param opts [Hash] Options to compare with current client options
    # @return [Boolean]
    def same_options?(opts)
      opts.hash == options.hash
    end


    def inspect # :nodoc:

      inspected = super

      # mask password
      inspected = inspected.gsub! @password, "*******" if @password
      # Only show last 4 of token, secret
      if @access_token
        inspected = inspected.gsub! @access_token, "#{'*'*36}#{@access_token[36..-1]}"
      end
      # if @client_secret
      #   inspected = inspected.gsub! @client_secret, "#{'*'*36}#{@client_secret[36..-1]}"
      # end

      inspected
    end

    # Hypermedia agent for the BIM360-Field API
    #
    # @return [Sawyer::Agent]
    def agent
      @agent ||= Sawyer::Agent.new(api_endpoint, sawyer_options) do |http|
        # http.headers[:accept] = "image/jpg"
        http.headers[:content_type]         = "application/json"
        http.headers[:user_agent]           = user_agent
        http.headers[:accept]               = "application/json"
        http.headers[:api_key]              = api_key
        http.headers[:'x-client-platform']  = "api"

        if @access_token
          http.headers.merge!({
            :'access-token'   => @access_token,
            :client           => @client_id,
            :expiry           => @expiry,
            :'token-type'     => "Bearer",
            :uid              => @uid
          })
        end

        # if
        # if basic_authenticated?
          # http.basic_auth(@login, @password)
        # elsif token_authenticated?
        #   http.authorization 'token', @access_token
        # end
      end
    end


    # Set username for authentication
    #
    # @param value [String] Nearmiss-field username
    def email=(value)
      reset_agent
      @email = value
    end

    # Set password for authentication
    #
    # @param value [String] Nearmiss-field password
    def password=(value)
      reset_agent
      @password = value
    end

    # Set OAuth access token for authentication
    #
    # @param value [String] 40 character Nearmiss-field API OAuth access token
    # def access_token=(value)
    #   reset_agent
    #   @access_token = value
    # end





    # Make a HTTP GET request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def get(url, options = {})
      request :get, url, options
    end

    def post(url, options = {})
      request :post, url, options
    end

    def put(url, options = {})
      request :put, url, options
    end

    def patch(url, options = {})
      request :patch, url, options
    end

    def delete(url, options = {})
      request :delete, url, options
    end

    # Response for last HTTP request
    #
    # @return [Sawyer::Response]
    def last_response
      @last_response if defined? @last_response
    end


    # Make one or more HTTP GET requests, optionally fetching
    # the next page of results from URL in Link response header based
    # on value in {#auto_paginate}.
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @param block [Block] Block to perform the data concatination of the
    #   multiple requests. The block is called with two parameters, the first
    #   contains the contents of the requests so far and the second parameter
    #   contains the latest response.
    # @return [Sawyer::Resource]
    def paginate(url, options = {}, &block)
      opts = parse_query_and_convenience_headers(options.dup)
      if @auto_paginate || @per_page
        opts[:query][:per_page] ||=  @per_page || (@auto_paginate ? 100 : nil)
      end

      data = request(:get, url, opts)

      if @auto_paginate
        while @last_response.rels[:next] #&& rate_limit.remaining > 0
          @last_response = @last_response.rels[:next].get
          if block_given?
            yield(data, @last_response)
          else
            data.concat(@last_response.data) if @last_response.data.is_a?(Array)
          end
        end

      end

      data
    end


    # Wrapper around Kernel#warn to print warnings unless
    # OCTOKIT_SILENT is set to true.
    #
    # @return [nil]
    def nearmiss_warn(*message)
      unless ENV['NEARMISS_SILENT']
        warn message
      end
    end



    private

    def reset_agent
      @agent = nil
    end

    # Make a HTTP Request
    #
    # @param method [Symbol] Http method e.g. :get, :post, :delete
    # @param path [String] path relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]

    def request(method, path, data, options = {})
      if data.is_a?(Hash)
        options[:query]   = data.delete(:query) || {}
        options[:headers] = data.delete(:headers) || {}
        if accept = data.delete(:accept)
          options[:headers][:accept] = accept
        end
      end

      if @access_token
        options[:headers].merge!({
          "access-token"  => @access_token,
          "client"        => @client_id,
          "expiry"        => @expiry,
          "token-type"    => "Bearer",
          "uid"           => @uid
        })
      end

      url = URI::Parser.new.escape(path.to_s)
      begin
        @last_response = response = agent.call(method, url, data, options)
        update_headers(response.headers)
        response.data
      rescue Faraday::ConnectionFailed => e
        @last_response = nil
        raise Nearmiss::ServerError.new
      end
    end

    def process_request(method, url, data = nil, options = nil)

      if [:get, :head].include?(method)
        options ||= data
        data      = nil
      end

      options ||= {}

      res = connection.send method, url do |req|
        if data
          req.body = data.is_a?(String) ? data : encode_body(data)
        end
        if params = options[:query]
          req.params.update params
        end
        if headers = options[:headers]
          req.headers.update headers
        end
        started = Time.now
      end
      


    end

    def connection
      @connection ||= begin
        conn_opts           = @connection_options
        conn_opts[:builder] = @middleware if @middleware
        conn_opts[:proxy]   = @proxy if @proxy
        Faraday.new(conn_opts)
      end
    end

    def serializer
      @serializer ||= MultiJson
    end

    def encode_body(data)
      serializer.encode(data)
    end

    # Decodes a String response body to a resource.
    #
    # str - The String body from the response.
    #
    # Returns an Object resource (Hash by default).
    def decode_body(str)
      serializer.decode(str)
    end

    def sawyer_options
      opts = {
        # :links_parser => Sawyer::LinkParsers::Simple.new
      }
      conn_opts           = @connection_options
      conn_opts[:builder] = @middleware if @middleware
      conn_opts[:proxy]   = @proxy if @proxy
      opts[:faraday]      = Faraday.new(conn_opts)

      opts
    end

    # Executes the request, checking if it was successful
    #
    # @return [Boolean] True on success, false otherwise
    def boolean_from_response(method, path, options = {})
      request(method, path, options)
      @last_response.status == 204
    rescue Nearmiss::NotFound
      false
    end


    def parse_query_and_convenience_headers(options)
      headers = options.fetch(:headers, {})
      CONVENIENCE_HEADERS.each do |h|
        if header = options.delete(h)
          headers[h] = header
        end
      end
      query = options.delete(:query)
      opts = {:query => options}
      opts[:query].merge!(query) if query && query.is_a?(Hash)
      opts[:headers] = headers unless headers.empty?

      opts
    end


  end


end
