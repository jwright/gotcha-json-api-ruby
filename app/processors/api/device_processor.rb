class API::DeviceProcessor < JSONAPI::Processor
  def create_resource
    current_user = context[:current_user]
    data = params[:data]
    token = data[:attributes][:token]

    if device = Device.find_by(token: token, player_id: current_user.id)
      resource = resource_klass.resource_for_model(device).new(device, context)
      status = :ok
    else
      resource = resource_klass.create(context)
      resource.replace_fields(
        data.deep_merge(attributes: { player_id: current_user.id,
                                      registered_at: DateTime.now })
      )
      status = :created
    end

    JSONAPI::ResourceOperationResult.new(status, resource)
  end
end
