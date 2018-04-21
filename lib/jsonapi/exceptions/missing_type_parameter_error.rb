require "action_controller"

module JSONAPI
  module Exceptions
    class MissingTypeParameterError < Exceptions::RuntimeError
      def errors
        [error(
          status: :bad_request,
          title: "Missing type",
          detail: ActionController::ParameterMissing.new(:type).message
        )]
      end
    end
  end
end
