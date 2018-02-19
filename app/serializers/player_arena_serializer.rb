require "fast_jsonapi"

class PlayerArenaSerializer
  include FastJsonapi::ObjectSerializer

  set_type :player_arena
  attributes :joined_at
  belongs_to :arena
end
