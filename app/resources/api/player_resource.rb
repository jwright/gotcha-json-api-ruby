class API::PlayerResource < JSONAPI::Resource
  attributes :api_key, :avatar, :email_address, :name, :password

  def self.creatable_fields(_context)
    super - [:api_key]
  end

  def self.updatable_fields(_context)
    super - [:api_key]
  end

  def fetchable_fields
    super - [:password]
  end
end
