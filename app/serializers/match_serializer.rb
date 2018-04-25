require "fast_jsonapi"

class MatchSerializer
  include FastJsonapi::ObjectSerializer

  set_type :match

  belongs_to :arena
  belongs_to :opponent
  belongs_to :seeker

  attribute :confirmation_code do |object|
    object.confirmation_code if object.pending?
  end

  attribute :found_at do |object|
    object.found_at.to_i if object.found?
  end

  attribute :matched_at do |object|
    object.matched_at.to_i
  end
end
