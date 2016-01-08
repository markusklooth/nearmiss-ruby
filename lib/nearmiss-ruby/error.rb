module Nearmiss
  # Custom error class for rescuing from all GitHub errors
  class Error < StandardError

    # Returns the appropriate Nearmiss::Error sublcass based
    # on status and response message
    #
    # @param [Hash] response HTTP response
    # @return [Nearmiss::Error]
    def self.from_response(response)
      status  = response[:status].to_i
      body    = response[:body].to_s
      headers = response[:response_headers]



      if klass =  case status
                  when 400      then Nearmiss::BadRequest
                  when 401      then Nearmiss::Unauthorized
                  when 403      then Nearmiss::Forbidden
                  when 404      then Nearmiss::NotFound
                  when 405      then Nearmiss::MethodNotAllowed
                  when 406      then Nearmiss::NotAcceptable
                  when 409      then Nearmiss::Conflict
                  when 415      then Nearmiss::UnsupportedMediaType
                  when 422      then Nearmiss::UnprocessableEntity
                  when 400..499 then Nearmiss::ClientError
                  when 500      then Nearmiss::InternalServerError
                  when 501      then Nearmiss::NotImplemented
                  when 502      then Nearmiss::BadGateway
                  when 503      then Nearmiss::ServiceUnavailable
                  when 500..599 then Nearmiss::ServerError
                  end
        klass.new(response)
      end
    end

    def initialize(response=nil)
      @response = response
      super(build_error_message)
    end

    # Array of validation errors
    # @return [Array<Hash>] Error info
    def errors
      if data && data.is_a?(Hash)
        data[:errors] || []
      else
        []
      end
    end

  # private

    def data
      @data ||=
        if (body = @response[:body]) && !body.empty?
          if body.is_a?(String) &&
            @response[:response_headers] &&
            @response[:response_headers][:content_type] =~ /json/

            Sawyer::Agent.serializer.decode(body)
          else
            body
          end
        else
          nil
        end
    end

    def response_message
      case data
      when Hash
        data[:message]
      when String
        data
      end
    end

    def response_error
      "Error: #{data[:error]}" if data.is_a?(Hash) && data[:error]
    end

    def response_error_summary
      return nil unless data.is_a?(Hash) && !Array(data[:errors]).empty?

      summary = "\nError summary:\n"
      # summary << data[:errors].map do |hash|
        # hash.map { |k,v| "  #{k}: #{v}" }
      # end.join("\n")
      summary << data[:errors].join("\n")
      summary
    end

    def build_error_message
      return nil if @response.nil?



      message =  "#{@response[:method].to_s.upcase} "
      message << redact_url(@response[:url].to_s) + ": "
      message << "#{@response[:status]} - "
      message << "#{response_message}" unless response_message.nil?
      message << "#{response_error}" unless response_error.nil?
      message << "#{response_error_summary}" unless response_error_summary.nil?
      # message << MultiJson.dump(@response)
      message
    end

    def redact_url(url_string)
      %w[client_secret access_token].each do |token|
        url_string.gsub!(/#{token}=\S+/, "#{token}=(redacted)") if url_string.include? token
      end
      url_string
    end

  end

  # Raised on errors in the 400-499 range
  class ClientError < Error; end

  # Raised when Nearmiss-Field returns a 400 HTTP status code
  class BadRequest < ClientError; end

  # Raised when Nearmiss-Field returns a 401 HTTP status code
  class Unauthorized < ClientError; end
  # Raised when Nearmiss-Field returns a 403 HTTP status code
  class Forbidden < ClientError; end

  # Raised when Nearmiss-Field returns a 403 HTTP status code
  # and body matches 'rate limit exceeded'
  class TooManyRequests < Forbidden; end

  # Raised when Nearmiss-Field returns a 403 HTTP status code
  # and body matches 'login attempts exceeded'
  class TooManyLoginAttempts < Forbidden; end

  # Raised when Nearmiss-Field returns a 404 HTTP status code
  class NotFound < ClientError; end

  # Raised when Nearmiss-Field returns a 405 HTTP status code
  class MethodNotAllowed < ClientError; end

  # Raised when Nearmiss-Field returns a 406 HTTP status code
  class NotAcceptable < ClientError; end

  # Raised when Nearmiss-Field returns a 409 HTTP status code
  class Conflict < ClientError; end

  # Raised when Nearmiss-Field returns a 414 HTTP status code
  class UnsupportedMediaType < ClientError; end

  # Raised when Nearmiss-Field returns a 422 HTTP status code
  class UnprocessableEntity < ClientError; end

  # Raised on errors in the 500-599 range
  class ServerError < Error; end

  # Raised when Nearmiss-Field returns a 500 HTTP status code
  class InternalServerError < ServerError; end

  # Raised when Nearmiss-Field returns a 501 HTTP status code
  class NotImplemented < ServerError; end

  # Raised when Nearmiss-Field returns a 502 HTTP status code
  class BadGateway < ServerError; end

  # Raised when Nearmiss-Field returns a 503 HTTP status code
  class ServiceUnavailable < ServerError; end

  # Raised when client fails to provide valid Content-Type
  class MissingContentType < ArgumentError; end

  # Raised when a method requires an application client_id
  # and secret but none is provided
  class ApplicationCredentialsRequired < StandardError; end

  class MissingParams < Error
    def initialize(msg)

      msg
    end
  end


end
