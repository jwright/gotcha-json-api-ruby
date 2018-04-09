class API::PlayerProcessor < JSONAPI::Processor
  after_create_resource do
    if result.is_a?(JSONAPI::ResourceOperationResult)
      player = result.resource._model
      player.update_attributes! api_key: TokenGenerator.generate
    end
  end
end
