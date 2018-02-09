FactoryBot.define do
  factory :player do
    first_name "Jimmy"
    last_name  "Page"
    sequence(:email_address) { |n| "person#{n}@example.com" }
    password "open sesame"
  end
end
