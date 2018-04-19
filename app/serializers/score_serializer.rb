require "fast_jsonapi"

class ScoreSerializer
  include FastJsonapi::ObjectSerializer

  set_type :score
  attributes :points
  belongs_to :arena
  belongs_to :player

  attribute :scored_at do |object|
    object.scored_at.to_i
  end
end
