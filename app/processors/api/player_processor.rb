class API::PlayerProcessor < JSONAPI::Processor
  after_show do
    if result.is_a?(JSONAPI::ResourceOperationResult)
      # Ensure that the player has access to this
      player = result.resource._model
      current_user = context[:current_user]

      Ability.new(current_user).authorize!(:read,
                                           player,
                                           message: "Player could not be found")

      # Do not pass back the API key when a client is viewing a player
      result.resource.fetchable_fields.delete(:api_key)
    end
  end

  after_create_resource do
    if result.is_a?(JSONAPI::ResourceOperationResult)
      player = result.resource._model
      player.update_attributes! api_key: TokenGenerator.generate
    end
  end
end
