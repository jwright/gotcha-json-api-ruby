module JSONAPI
  module Exceptions
    class TypeMismatchError < Exceptions::RuntimeError
      def initialize(type)
        @detail = "#{type} is not a valid type for this operation"
      end

      def errors
        [error(
          status: :bad_request,
          title: "Invalid type",
          detail: @detail
        )]
      end
    end
  end
end
