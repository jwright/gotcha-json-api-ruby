require "fast_jsonapi"

class ArenaSerializer
  include FastJsonapi::ObjectSerializer

  set_type :arena
  attributes :location_name,
             :latitude,
             :longitude,
             :street_address1,
             :street_address2,
             :city,
             :state,
             :zip_code
end
