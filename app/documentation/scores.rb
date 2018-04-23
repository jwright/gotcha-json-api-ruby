module Documentation
  module Scores
    def self.included(base)

      base.class_eval do
        swagger_path "/scores" do
          operation :get do
            key :summary, "Find scores"
            key :description, "Returns all of the scores that can be filtered"
            key :tags, ["SCORES"]
            security do
              key :Bearer, []
            end
            parameter do
              key :name, "filter[arena]"
              key :type, :number
              key :in, :query
              key :description, "The id of the arena to get the scores for"
              key :required, false
            end
            parameter do
              key :name, "filter[player]"
              key :type, :number
              key :in, :query
              key :description, "The id of the player to get the scores for"
              key :required, false
            end
            response 200 do
              key :description, "A JSON API formatted representation of an array of Scores"
              schema do
                key :type, :array
                items do
                  key :"$ref", :Score
                end
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
