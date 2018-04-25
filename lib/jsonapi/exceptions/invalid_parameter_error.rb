module JSONAPI
  module Exceptions
    class InvalidParameterError < Exceptions::RuntimeError
      def initialize(message)
        @detail = message
      end

      def errors
        [error(
          status: :bad_request,
          title: "Invalid parameter",
          detail: @detail
        )]
      end
    end
  end
end
