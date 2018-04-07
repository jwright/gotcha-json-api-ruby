FactoryBot.define do
  factory :score do
    arena
    player
    points 1
    scored_at { DateTime.now }
  end
end
