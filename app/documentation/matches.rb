module Documentation
  module Matches
    def self.included(base)
      base.class_eval do

        swagger_path "/matches/:id/capture" do
          operation :post do
            key :summary, "Mark the match as found between the seeker and the opponent"
            key :description, "Marks the match as found and starts new matches "\
                              "for both the seeker and the opponent."
            key :tags, ["MATCHES"]
            security do
              key :Bearer, []
            end
            response 200 do
              key :description, "A JSON API formatted representation of the single Match that was found."
              schema do
                key :"$ref", :Match
              end
              example name: JSONAPI::MEDIA_TYPE do
                key :data, {
                  id: "12345",
                  type: "match",
                  attributes: {
                    found_at: 5632493294,
                    matched_at: 783287834764,
                  },
                  relationships: {
                    arena: {
                      data: {
                        id: "67893",
                        type: "arena"
                      }
                    },
                    opponent: {
                      data: {
                        id: "53273",
                        type: "player"
                      }
                    },
                    seeker: {
                      data: {
                        id: "77349543",
                        type: "player"
                      }
                    }
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
                key :errors, "Unauthorized"
              end
            end
          end
        end

        swagger_schema :Match do
          key :type, :object
          key :required, [:id,
                          :type,
                          :matched_at]
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
              key :enum, ["match"]
            end
            property :attributes do
              key :type, :object
              property :found_at do
                key :type, :integer
                key :format, :dateTime
                key :description, "The date/time of when the player was found in "\
                                  "the match in the number of seconds since the Epoch"
              end
              property :matched_at do
                key :type, :integer
                key :format, :dateTime
                key :description, "The date/time of when the player was placed in "\
                                  "the match in the number of seconds since the Epoch"
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
                property :opponent do
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
                property :seeker do
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
        end

      end
    end
  end
end
