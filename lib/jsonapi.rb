require_relative "jsonapi/exceptions"

module JSONAPI
  MEDIA_TYPE = "application/vnd.api+json"

  class UnauthorizedError < RuntimeError
    def initialize
      super "Not authorized"
    end
  end
end
