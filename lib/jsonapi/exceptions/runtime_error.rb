module JSONAPI
  module Exceptions
    class RuntimeError < ::RuntimeError
      def errors
        raise NotImplementedException
      end

      def status
        errors.first.try(:status) || :bad_request
      end

      protected

      def error(options)
        JSONAPI::Exceptions::Error.new(options)
      end
    end
  end
end
