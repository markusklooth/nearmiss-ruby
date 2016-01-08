module Nearmiss
  class Client

    # Methods for API rate limiting info
    #
    # @see https://developer.github.com/v3/#rate-limiting
    module RateLimit

      # Get rate limit info from last response if available
      # or make a new request to fetch rate limit
      #
      # @see https://developer.github.com/v3/rate_limit/#rate-limit
      # @return [Nearmiss::RateLimit] Rate limit info
      def rate_limit(options = {})
        return rate_limit! if last_response.nil?

        Nearmiss::RateLimit.from_response(last_response)
      end
      alias ratelimit rate_limit

      # Get number of rate limted requests remaining
      #
      # @see https://developer.github.com/v3/rate_limit/#rate-limit
      # @return [Fixnum] Number of requests remaining in this period
      def rate_limit_remaining(options = {})
        nearmiss_warn "Deprecated: Please use .rate_limit.remaining"
        rate_limit.remaining
      end
      alias ratelimit_remaining rate_limit_remaining

      # Refresh rate limit info by making a new request
      #
      # @return [Nearmiss::RateLimit] Rate limit info
      def rate_limit!(options = {})
        get "rate_limit"
        Nearmiss::RateLimit.from_response(last_response)
      end
      alias ratelimit! rate_limit!

      # Refresh rate limit info and get number of rate limted requests remaining
      #
      # @return [Fixnum] Number of requests remaining in this period
      def rate_limit_remaining!(options = {})
        nearmiss_warn "Deprecated: Please use .rate_limit!.remaining"
        rate_limit!.remaining
      end
      alias ratelimit_remaining! rate_limit_remaining!

    end
  end
end

