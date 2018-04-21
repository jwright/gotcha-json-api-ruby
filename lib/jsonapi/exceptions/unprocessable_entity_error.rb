module JSONAPI
  module Exceptions
    class UnprocessableEntityError < Exceptions::RuntimeError
      def initialize(validation_errors)
        @validation_errors = validation_errors
      end

      def errors
        @validation_errors.map do |attribute, message|
          error(
            status: :unprocessable_entity,
            title: message,
            detail: detail(attribute, message),
            source: { pointer: pointer(attribute) }
          )
        end
      end

      private

      def base_error?(attribute)
        attribute.to_s == "base"
      end

      def detail(attribute, message)
        if base_error?(attribute)
          message
        else
          "#{attribute.to_s.humanize} #{message}"
        end
      end

      def pointer(attribute)
        "/data/attributes/#{attribute}"
      end
    end
  end
end
