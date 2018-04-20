class API::MatchResource < JSONAPI::Resource
  attributes :found_at, :matched_at

  has_one :arena
  has_one :opponent
  has_one :seeker
end
