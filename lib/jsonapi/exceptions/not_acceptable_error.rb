module JSONAPI
  module Exceptions
    class NotAcceptableError < Exceptions::RuntimeError
      def initialize(media_type)
        @detail = "#{media_type} is not a valid ACCEPT header for "\
                  "this operation"
      end

      def errors
        [error(
          status: :not_acceptable,
          title: "Not Acceptable",
          detail: @detail
        )]
      end
    end
  end
end
