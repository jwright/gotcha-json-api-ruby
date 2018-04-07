FactoryBot.define do
  factory :score do
    arena
    player
    points 1
    scored_at { DateTime.now }

    before(:create) do |score|
      if score.arena && score.player
        score.player.arenas << score.arena
      end
    end
  end
end
