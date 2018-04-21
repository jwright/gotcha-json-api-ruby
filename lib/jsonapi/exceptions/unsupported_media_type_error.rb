module JSONAPI
  module Exceptions
    class UnsupportedMediaTypeError < Exceptions::RuntimeError
      def initialize(media_type)
        @detail = "#{media_type} is not a valid Content-Type header for "\
                  "this operation"
      end

      def errors
        [error(
          status: :unsupported_media_type,
          title: "Unsupported Media Type",
          detail: @detail
        )]
      end
    end
  end
end
