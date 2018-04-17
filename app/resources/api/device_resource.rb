class API::DeviceResource < JSONAPI::Resource
  attributes :registered_at, :token

  key_type :string

  def self.find_by_key(key, options={})
    current_user = options[:context][:current_user]
    model = Device.find_by token: key, player_id: current_user.id

    fail JSONAPI::Exceptions::RecordNotFound.new(key) if model.nil?

    resource_for_model(model).new(model, options[:context])
  end

  private

  def player_id=(player_id)
    _model.player_id = player_id
  end
end
