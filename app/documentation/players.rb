module Documentation
  module Players
    def self.included(base)
      base.class_eval do

        swagger_path "/players" do
          operation :post do
            key :summary, "Register a new player"
            key :description, "Creates a new player with the information passed in"
            key :tags, ["PLAYERS"]
            parameter do
              key :name, :attributes
              key :type, :object
              key :in, :body
              key :description, "The attributes of the new player"
              schema do
                key :"$ref", :PlayerInput
              end
            end
            response 201 do
              key :description, "A JSON API formatted representation of a single Player"
              schema do
                key :"$ref", :Player
              end
              example name: JSONAPI::MEDIA_TYPE do
                key :data, [{
                  id: "12345",
                  type: "player",
                  attributes: {
                    name: "Jimmy Page",
                    email_address: "jimmy@example.org",
                    avatar: "SOME BASE 64 STRING",
                    api_key: "API_TOKEN",
                  }
                }]
              end
            end
            response 422 do
              key :description, "Unprocessable entity"
              schema do
                key :type, :string
              end
              example name: JSONAPI::MEDIA_TYPE do
                key :errors, "Password can't be blank. Email address is already registered."
              end
            end
          end
        end

        swagger_schema :Player do
          key :type, :object
          property :data do
            key :type, :object
            property :id do
              key :type, :string
              key :format, :int64
              key :description, "Unique identifier for the object"
            end
            property :type do
              key :type, :string
              key :description, "Type of the object being returned"
            end
            property :attributes do
              key :type, :object
              property :name do
                key :type, :string
                key :description, "Full name for the player"
              end
              property :email_address do
                key :type, :string
                key :description, "Email address for the player"
              end
              property :avatar do
                key :type, :string
                key :description, "Url for the avatar for a player"
              end
              property :api_key do
                key :type, :string
                key :description, "API key for the player"
              end
            end
          end
        end

        swagger_schema :PlayerInput do
          key :type, :object
          key :required, [:data]
          property :data do
            key :type, :object
            key :required, [:attributes]
            property :type do
              key :type, :string
              key :description, "Type of the object being created"
            end
            property :attributes do
              key :type, :object
              key :required, [:name, :email_address, :password]
              property :name do
                key :type, :string
                key :description, "Full name for the player"
              end
              property :email_address do
                key :type, :string
                key :description, "Email address for the player"
              end
              property :password do
                key :type, :string
                key :description, "Requested password for the player"
              end
              property :avatar do
                key :type, :string
                key :description, "Base64 image for the avatar for the player"
              end
            end
          end
        end

      end
    end
  end
end
