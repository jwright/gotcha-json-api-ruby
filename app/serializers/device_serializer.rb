require "fast_jsonapi"

class DeviceSerializer
  include FastJsonapi::ObjectSerializer

  set_type :device
  attributes :registered_at, :token
  belongs_to :player
end
