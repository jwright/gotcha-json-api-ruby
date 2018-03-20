FactoryBot.define do
  factory :device do
    player
    sequence(:token) { |n| "DEVICE_#{n.to_s.rjust(3, "0")}" }
    registered_at { DateTime.now }
  end
end
