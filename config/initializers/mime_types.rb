require "jsonapi"

Mime::Type.unregister :json
Mime::Type.register JSONAPI::MEDIA_TYPE, :json
