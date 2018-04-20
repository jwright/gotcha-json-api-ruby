require_relative "jsonapi/exceptions"

module JSONAPI
  MEDIA_TYPE = "application/vnd.api+json"

  class MissingTypeParameterError < RuntimeError
    def initialize
      super ActionController::ParameterMissing.new(:type).message
    end
  end

  class NotAcceptableError < RuntimeError
    attr_reader :media_type

    def initialize(media_type)
      @media_type = media_type
      super "Not Acceptable"
    end
  end

  class UnauthorizedError < RuntimeError
    def initialize
      super "Not authorized"
    end
  end

  class UnsupportedMediaTypeError < RuntimeError
    attr_reader :media_type

    def initialize(media_type)
      @media_type = media_type
      super "Unsupported Media Type"
    end
  end
end
