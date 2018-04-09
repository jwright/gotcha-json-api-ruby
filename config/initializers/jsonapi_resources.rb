module JSONAPI
  module Exceptions

    # Override the default formatting of the detail message of validation
    # errors. The original implementation is `title: "brand - must exist"`
    # and we want it more human readable to be something like
    # `title: "Brand must exist"`

    class ValidationErrors < Error
      private

      def json_api_error(attr_key, message)
        create_error_object(code: JSONAPI::VALIDATION_ERROR,
                            status: :unprocessable_entity,
                            title: message,
                            detail: detail(attr_key, message),
                            source: { pointer: pointer(attr_key) },
                            meta: metadata_for(attr_key, message))
      end

      # Humanize the attr key from a dasherized name `campaign-contents`
      # to something more readable like `Campaign contents`
      def detail(attr_key, message)
        "#{attr_key.to_s.humanize} #{message}"
      end
    end
  end
end

JSONAPI.configure do |config|
  config.json_key_format = :underscored_key
end
