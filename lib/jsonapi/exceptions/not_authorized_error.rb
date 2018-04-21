module JSONAPI
  module Exceptions
    class NotAuthorizedError < Exceptions::RuntimeError
      def initialize(message="Not Authorized")
        @detail = message
      end

      def errors
        [error(
          status: :unauthorized,
          title: "Not Authorized",
          detail: @detail
        )]
      end
    end
  end
end
