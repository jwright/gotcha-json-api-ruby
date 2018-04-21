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
                key :type, :array
                items do
                  key :"$ref", :Error
                end
              end
              example name: JSONAPI::MEDIA_TYPE do
                key :errors, [{
                  code: 401,
                  detail: "Not authorized",
                  status: 401,
                  title: "Not authorized",
                }]
              end
            end
          end
        end

        swagger_path "/arenas/{id}/play" do
          operation :post do
            key :summary, "Assign a player to an arena"
            key :description, "Allows for a player to play within an arena by "\
                              "assigning a player to the arena."
            key :tags, ["ARENAS"]
            security do
              key :Bearer, []
            end
            response 200 do
              key :description, "A JSON API formatted representation of a single "\
                                "Arena attached to a player. A 200 is returned "\
                                "if the player is already playing the arena."
              schema do
                key :"$ref", :Arena
              end
              example name: JSONAPI::MEDIA_TYPE do
                key :data, {
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
                }
              end
            end
            response 201 do
              key :description, "A JSON API formatted representation of a single "\
                                "Arena attached to a player"
              schema do
                key :"$ref", :Arena
              end
              example name: JSONAPI::MEDIA_TYPE do
                key :data, {
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
                }
              end
            end
            response 401 do
              key :description, "Unauthorized"
              schema do
                key :type, :array
                items do
                  key :"$ref", :Error
                end
              end
              example name: JSONAPI::MEDIA_TYPE do
                key :errors, [{
                  code: 401,
                  detail: "Not authorized",
                  status: 401,
                  title: "Not authorized",
                }]
              end
            end
          end
        end

        swagger_path "/arenas/{id}/leave" do
          operation :post do
            key :summary, "Remove a player from an arena"
            key :description, "Removes a player from an arena by removing the "\
                              "assigned player so they can no longer be found there."
            key :tags, ["ARENAS"]
            security do
              key :Bearer, []
            end
            response 204 do
              key :description, "No content is returned."
            end
            response 401 do
              key :description, "Unauthorized"
              schema do
                key :type, :array
                items do
                  key :"$ref", :Error
                end
              end
              example name: JSONAPI::MEDIA_TYPE do
                key :errors, [{
                  code: 401,
                  detail: "Not authorized",
                  status: 401,
                  title: "Not authorized",
                }]
              end
            end
          end
        end

        swagger_path "/arenas/{id}/scores" do
          operation :get do
            key :summary, "Retrieve the scores for an arena and current user"
            key :description, "Retrieve the scores for the arena and the current user"
            key :tags, ["ARENAS"]
            security do
              key :Bearer, []
            end
            response 200 do
              key :description, "A JSON API formatted representation of an array of "\
                                "Scores attached to a player for the arena."
              schema do
                key :"$ref", :Score
              end
              example name: JSONAPI::MEDIA_TYPE do
                key :data, [{
                  id: "12345",
                  type: "score",
                  attributes: {
                    points: 1,
                    scored_at: 734723433
                  },
                  relationships: {
                    arena: {
                      data: {
                        id: "12345",
                        type: "arena"
                      }
                    },
                    player: {
                      data: {
                        id: "12345",
                        type: "player"
                      }
                    }
                  }
                }]
                key :meta, {
                  total_points: 1,
                  placement: "1st"
                }
              end
            end
            response 401 do
              key :description, "Unauthorized"
              schema do
                key :type, :array
                items do
                  key :"$ref", :Error
                end
              end
              example name: JSONAPI::MEDIA_TYPE do
                key :errors, [{
                  code: 401,
                  detail: "Not authorized",
                  status: 401,
                  title: "Not authorized",
                }]
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

        swagger_schema :Score do
          key :type, :object
          key :required, [:id,
                          :type,
                          :scored_at]
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
              key :enum, ["score"]
            end
            property :attributes do
              key :type, :object
              property :points do
                key :type, :integer
                key :description, "The number of points aquired for that score"
              end
              property :scored_at do
                key :type, :integer
                key :format, :dateTime
                key :description, "The date/time of when the score was scored "\
                                  "in the number of seconds since the Epoch"
              end
            end
            property :relationships do
              key :type, :object
              property :data do
                key :type, :object
                property :arena do
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
                end
                property :player do
                  key :type, :object
                  property :id do
                    key :type, :string
                    key :format, :int64
                    key :description, "Unique identifier for the object"
                  end
                  property :type do
                    key :type, :string
                    key :description, "The type of object that is represented"
                    key :enum, ["player"]
                  end
                end
              end
            end
          end
          property :meta do
            key :type, :object
            property :total_points do
              key :type, :integer
              key :description, "The total number of points for the player in that arena"
            end
            property :placement do
              key :type, :string
              key :description, "The ordinal for the place of the player in that "\
                                "arena (i.e. 1st, 2nd). It returns '-' if there "\
                                "are no scores."
            end
          end
        end

      end
    end
  end
end
