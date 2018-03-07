module Documentation
  module Arenas
    def self.included(base)
      base.class_eval do
        swagger_path "/arenas" do
          operation :get do
            key :summary, "Find nearby arenas"
            key :description, "Returns all of the arenas that are within 5 miles of "\
                              "latitude and longitude passed in."
            key :tags, ["ARENAS"]
            security do
              key :Bearer, []
            end
            parameter do
              key :name, :latitude
              key :type, :number
              key :in, :query
              key :description, "The latitude value for where the arenas should be near"
              key :required, true
            end
            parameter do
              key :name, :longitude
              key :type, :number
              key :in, :query
              key :description, "The longitude value for where the arenas should be near"
              key :required, true
            end
            response 200 do
              key :description, "A JSON API formatted representation of an array of Arenas"
              schema do
                key :type, :array
                items do
                  key :"$ref", :Arena
                end
              end
              example name: JSONAPI::MEDIA_TYPE do
                key :data, [{
                  id: "12345",
                  type: "arena",
                  attributes: {
                    location_name: "Staples Center",
                    latitude: 34.0430219,
                    longitude: -118.2694428,
                    street_address1: "1111 S Figueroa St",
                    street_address2: "",
                    city: "Los Angeles",
                    state: "CA",
                    zip_code: "90015"
                  }
                }]
              end
            end
            response 401 do
              key :description, "Unauthorized"
              schema do
                key :type, :string
              end
              example name: JSONAPI::MEDIA_TYPE do
                key :errors, "Unauthorized"
              end
            end
          end
        end

        swagger_schema :Arena do
          key :type, :object
          key :required, [:id,
                          :type,
                          :location_name,
                          :latitude,
                          :longitude,
                          :street_address1,
                          :city,
                          :state,
                          :zip_code]
          property :data do
            key :type, :object
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
            property :attributes do
              key :type, :object
              property :location_name do
                key :type, :string
                key :description, "Name of the location where the Arena is located"
              end
              property :longitude do
                key :type, :number
                key :description, "The longitude for the location where the "\
                                  "Arena is located"
              end
              property :latitude do
                key :type, :number
                key :description, "The latitude for the location where the "\
                                  "Arena is located"
              end
              property :street_address1 do
                key :type, :string
                key :description, "The first line of the street address for "\
                                  "the location where the Arena is located"
              end
              property :street_address2 do
                key :type, :string
                key :description, "The second line of the street address for "\
                                  "the location where the Arena is located"
              end
              property :city do
                key :type, :string
                key :description, "The city of the street address for "\
                                  "the location where the Arena is located"
              end
              property :state do
                key :type, :string
                key :description, "The state of the street address for "\
                                  "the location where the Arena is located"
              end
              property :zip_code do
                key :type, :string
                key :description, "The zip code of the street address for "\
                                  "the location where the Arena is located"
              end
            end
          end
        end

      end
    end
  end
end
