require "fast_jsonapi"

class PlayerArenaSerializer
  include FastJsonapi::ObjectSerializer

  set_type :player_arena
  attributes :joined_at
  belongs_to :arena

  def joined_at
    record.joined_at.to_i
  end
end
