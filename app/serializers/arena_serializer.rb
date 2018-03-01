require "fast_jsonapi"

class ArenaSerializer
  include FastJsonapi::ObjectSerializer
  include Swagger::Blocks

  swagger_schema :Arena do
    key :type, :object
    key :required, [:id, :location_name, :type]
    property :id do
      key :type, :string
      key :format, :int64
      key :description, "Unique identifier for the object"
    end
    property :type do
      key :type, :string
      key :description, "The type of object that is represented"
      key :enum, ["arena"]
    end
    property :location_name do
      key :type, :string
      key :description, "Name of the location where the Arena is located"
    end
  end

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
