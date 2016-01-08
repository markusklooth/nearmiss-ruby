module Nearmiss
  module Configurable
    
    attr_accessor :middleware, :proxy, :user_agent, :connection_options, :api_key, :auto_paginate, :per_page
    attr_writer :password, :api_endpoint, :email

    # Define static methods
    class << self
      
      def keys
        @keys ||= [
          :middleware,
          :proxy,
          :user_agent,
          :connection_options,
          :password,
          :api_endpoint,
          :api_key,
          :email,
          :auto_paginate,
          :per_page
        ]
      end
    end

    # Set configuration options using a block
    def configure
      yield self
    end

    # Reset configuration options to default values
    def reset!
      Nearmiss::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", Nearmiss::Default.options[key])
      end
      self
    end
    alias setup reset!

    def api_endpoint
      File.join(@api_endpoint, "")
    end

    def options
      Hash[Nearmiss::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

  private


  
  end  
end