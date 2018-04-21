module JSONAPI
  module Exceptions
    class RecordNotFoundError < Exceptions::RuntimeError
      def initialize(exception)
        if exception.model.present?
          @detail = "#{exception.model} with #{exception.primary_key} "\
                    "#{exception.id} not found"
        else
          @detail = exception.message
        end
      end

      def errors
        [error(
          status: :not_found,
          title: "Resource not found",
          detail: @detail
        )]
      end
    end
  end
end
