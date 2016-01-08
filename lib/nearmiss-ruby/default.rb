# require "bim360/version" unless defined?(Nearmiss::VERSION)
# require 'bim360/response/raise_error'

module Nearmiss


  # Default configuration options for {Client}
  module Default

    # config = YAML.load_file(File.join(Rails.root, 'secrets/secrets.yml'))['nearmiss']

    # Default API endpoint
    API_ENDPOINT  = "http://nearmissapp.com".freeze

    # Default User Agent header string
    USER_AGENT    = "Nearmiss Ruby Gem #{Nearmiss::VERSION}".freeze

    API_KEY       = "WEBCOR".freeze

    # Default Faraday middleware stack
    # MIDDLEWARE =


    class << self

      # Configuration options
      # @return [Hash]
      def options
        Hash[Nearmiss::Configurable.keys.map{|key| [key, send(key)]}]
      end

      # Default access token from ENV
      # @return [String]
      def access_token
        ENV['NEARMISS_ACCESS_TOKEN']
      end

      def client_id

      end

      def uid

      end

      def expiry

      end

      def user

      end


      def config
        @config ||= {}
      end

      # Default API endpoint from ENV or {API_ENDPOINT}
      # @return [String]
      def api_endpoint
        ENV['NEARMISS_API_ENDPOINT'] || API_ENDPOINT
      end

      # Default BIM360-Field username for Basic Auth from ENV
      # @return [String]
      def email
        ENV['NEARMISS_EMAIL'] || config['email']
      end

      # Default BIM360-Field password for Basic Auth from ENV
      # @return [String]
      def password
        ENV['NEARMISS_PASSWORD'] || config['password']
      end

      # def ticket
      #   ENV['NEARMISS_TICKET']
      # end

      # Default proxy server URI for Faraday connection from ENV
      # @return [String]
      def proxy
        ENV['NEARMISS_PROXY']
      end

      # Default options for Faraday::Connection
      # @return [Hash]
      def connection_options
        {
          :headers => {
            # :accept => default_media_type,
            :user_agent => user_agent
          }
        }
      end


      # Default middleware stack for Faraday::Connection
      # from {MIDDLEWARE}
      # @return [String]
      def middleware
        Faraday::RackBuilder.new do |builder|
          builder.use Nearmiss::Response::RaiseError
          builder.adapter Faraday.default_adapter
        end
      end

      # Default pagination preference from ENV
      # @return [String]
      def auto_paginate
        ENV['NEARMISS_AUTO_PAGINATE'] || true
      end

      # Default pagination page size from ENV
      # @return [Fixnum] Page size
      def per_page
        page_size = ENV['NEARMISS_PER_PAGE']

        page_size.to_i if page_size
      end


      # Default User-Agent header string from ENV or {USER_AGENT}
      # @return [String]
      def user_agent
        ENV['NEARMISS_USER_AGENT'] || USER_AGENT
      end

      def api_key
        ENV['NEARMISS_API_KEY'] || API_KEY
      end

    end

  end
end
