require "rack"

module JSONAPI
  module Exceptions
    class Error
      attr_accessor :code,
                    :detail,
                    :id,
                    :links,
                    :meta,
                    :source,
                    :status,
                    :title

      def initialize(options={})
        @detail = options[:detail]
        @id = options[:id]
        @links = options[:links] || []
        @meta = options[:meta] || {}
        @source = options[:source] || {}
        @status = get_status(options[:status])
        @code = options[:code] || @status
        @title = options[:title]
      end

      def to_hash
        instance_variables.map do |var|
          [var.to_s.delete("@"), instance_variable_get(var)]
        end.to_h
      end

      private

      def get_status(status)
        if status.is_a? Symbol
          Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
        else
          status
        end
      end
    end
  end
end
