require "set"
require "faraday"
require "sawyer"

require "nearmiss-ruby/response"
require "nearmiss-ruby/error"
require "nearmiss-ruby/raise_error"
require "nearmiss-ruby/version"

require "nearmiss-ruby/configurable"
require "nearmiss-ruby/response"
require "nearmiss-ruby/client"
require "nearmiss-ruby/default"
require "nearmiss-ruby/util"

module Nearmiss

  class << self

    include Nearmiss::Configurable
    include Nearmiss::Util

    # API client based on configured options {Configurable}
    #
    # @return [Nearmiss::Client] API wrapper
    def client
      @client = Nearmiss::Client.new(options) unless defined?(@client) && @client.same_options?(options)
      @client
    end

    # @private
    def respond_to_missing?(method_name, include_private=false)
      client.respond_to?(method_name, include_private)
    end

  private

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end


  end
end
Nearmiss.setup
