require "fast_jsonapi"

class PlayerSerializer
  include FastJsonapi::ObjectSerializer

  set_type :player
  attributes :avatar, :email_address, :first_name, :last_name
end
