require "fast_jsonapi"

class DeviceSerializer
  include FastJsonapi::ObjectSerializer

  set_type :device
  attributes :token
  belongs_to :player

  attribute :registered_at do |object|
    object.registered_at.to_i
  end
end
