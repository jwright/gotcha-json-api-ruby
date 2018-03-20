require "fast_jsonapi"

class DeviceSerializer
  include FastJsonapi::ObjectSerializer

  set_type :device
  attributes :registered_at, :token
  belongs_to :player

  def initialize(resource, options={})
    super
    @record = DeviceDecorator.new(@record)
  end

  private

  class DeviceDecorator < SimpleDelegator
    def registered_at
      __getobj__.registered_at.to_i
    end
  end
end
