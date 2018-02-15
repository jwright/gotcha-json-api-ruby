FactoryBot.define do
  factory :arena do
    location_name "Denver Auditorium Arena"
    street_address1 "14th and Arapahoe Street"
    city "Denver"
    state "Colorado"
    zip_code "80204"
    latitude { 39.744444 }
    longitude { -104.9975 }
  end
end
