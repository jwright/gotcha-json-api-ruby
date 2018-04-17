class API::SessionResource < JSONAPI::Resource
  attributes :email_address, :password

  model_name "Player"
end
