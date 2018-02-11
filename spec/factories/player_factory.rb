FactoryBot.define do
  factory :player do
    name "Jimmy Page"
    sequence(:email_address) { |n| "person#{n}@example.com" }
    password "open sesame"
  end
end
