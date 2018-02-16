FactoryBot.define do
  factory :player do
    name "Jimmy Page"
    sequence(:email_address) { |n| "person#{n}@example.com" }
    password "open sesame"

    trait :authorized do
      api_key { TokenGenerator.generate }
    end
  end
end
