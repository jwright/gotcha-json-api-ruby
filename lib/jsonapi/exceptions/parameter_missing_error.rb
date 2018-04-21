require "action_controller"

module JSONAPI
  module Exceptions
    class ParameterMissingError < Exceptions::RuntimeError
      def initialize(message)
        @detail = message
      end

      def errors
        [error(
          status: :bad_request,
          title: "Parmeter missing",
          detail: @detail
        )]
      end
    end
  end
end
