FactoryBot.define do
  factory :match do
    association :seeker, factory: :player
    association :opponent, factory: :player
    arena
    matched_at { DateTime.now }

    trait :found do
      found_at { DateTime.now }
    end

    trait :ignored do
      ignored_at { DateTime.now }
    end

    trait :pending do
      pending_at { DateTime.now }
    end
  end
end
