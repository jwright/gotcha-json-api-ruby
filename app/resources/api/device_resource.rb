class API::DeviceResource < JSONAPI::Resource
  attributes :registered_at, :token

  key_type :string

  def self.find_by_key(key, options={})
    model = Device.find_by_token key
    fail JSONAPI::Exceptions::RecordNotFound.new(key) if model.nil?
    resource_for_model(model).new(model, options[:context])
  end
end
