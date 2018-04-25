module JSONAPI
  module Exceptions
    class PreconditionFailedError < Exceptions::RuntimeError
      def initialize(message)
        @detail = message
      end

      def errors
        [error(
          status: :precondition_failed,
          title: "Precondition failed",
          detail: @detail
        )]
      end
    end
  end
end
