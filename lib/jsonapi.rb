module JSONAPI
  MEDIA_TYPE = "application/vnd.api+json"

  class NotAcceptableError < RuntimeError
    attr_reader :media_type

    def initialize(media_type)
      @media_type = media_type
      super "Not Acceptable"
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
