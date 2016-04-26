module Nearmiss

  # Authentication methods for {Nearmiss::Client}
  module Authentication

    # Indicates if the client was supplied  Basic Auth
    # username and password
    #
    # @see
    # @return [Boolean]
    def basic_authenticated?
      !!(@email && @password)
    end

    # Indicates if the client was supplied an OAuth
    # access token
    #
    # @see
    # @return [Boolean]
    def token_authenticated?
      !!@access_token
    end

    def sign_in

      response  = post 'auth/sign_in', { email: @email, password: @password}
      update_headers(last_response && last_response.headers)
      reset_agent
      @me       = response && response[:data] #&& response[:data]
    end
    alias :login :sign_in

    def update_headers(headers)
      headers ||= {}
      # puts "update"
      # last_response.headers
      @client_id    = headers["client"]
      @access_token = headers["access-token"]
      @expiry       = headers["expiry"]
      @uid          = headers["uid"]

    end

    # Closes the current active session by expiring the ticket.
    #
    def sign_out
      post "api/logout"
      @me = nil
    end
    alias :logout :sign_out

    # Check is a user is currently signed in.
    #
    # @return [Boolean]
    def signed_in?
      !!@me
    end

  end

end
