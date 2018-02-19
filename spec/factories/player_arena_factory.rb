FactoryBot.define do
  factory :player_arena do
    player
    arena
    joined_at { 2.days.ago }
  end
end
