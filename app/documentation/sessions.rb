module Documentation
  module Sessions
    def self.included(base)
      base.class_eval do

        swagger_path "/sessions" do
          operation :post do
            key :summary, "Logs in a player"
            key :description, "Logs in a player with an email and password."
            key :tags, ["SESSIONS"]
            parameter do
              key :name, :attributes
              key :type, :object
              key :in, :body
              key :description, "The email address and password to log in with"
              schema do
                key :"$ref", :AuthenticationInput
              end
            end
            response 200 do
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
            response 401 do
              key :description, "Unauthorized"
              schema do
                key :type, :string
              end
              example name: JSONAPI::MEDIA_TYPE do
                key :errors, "Not authorized"
              end
            end
          end
        end

        swagger_schema :AuthenticationInput do
          key :type, :object
          key :required, [:data]
          property :data do
            key :type, :object
            key :required, [:attributes]
            property :attributes do
              key :type, :object
              key :required, [:email_address, :password]
              property :email_address do
                key :type, :string
                key :description, "Email address for the player"
              end
              property :password do
                key :type, :string
                key :description, "Password for the player"
              end
            end
          end
        end

      end
    end
  end
end
