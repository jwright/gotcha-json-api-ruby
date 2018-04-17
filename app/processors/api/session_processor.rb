class API::SessionProcessor < JSONAPI::Processor
  def create_resource
    attributes = params[:data][:attributes]

    player = Player.authenticate(attributes[:email_address],
                                 attributes[:password])

    raise JSONAPI::Exceptions::NotAuthorized,
      "Invalid email address or password" if player.nil?

    if player.api_key.nil?
      player.update_attributes! api_key: TokenGenerator.generate
    end

    resource = API::PlayerResource.new(player, context: context)
    JSONAPI::ResourceOperationResult.new(:ok, resource)
  end
end
