module Documentation
  module Devices
    def self.included(base)
      base.class_eval do

        swagger_path "/devices" do
          operation :post do
            key :summary, "Registers a device"
            key :description, "Registers a device so it can retrieve notifications "\
                              "when a match is created."
            key :tags, ["DEVICES"]
            security do
              key :Bearer, []
            end
            parameter do
              key :name, :attributes
              key :type, :object
              key :in, :body
              key :description, "The device information to register"
              schema do
                key :"$ref", :DeviceInput
              end
            end
            response 201 do
              key :description, "A JSON API formatted representation of a single Device"
              schema do
                key :"$ref", :Device
              end
              example name: JSONAPI::MEDIA_TYPE do
                key :data, [{
                  id: "12345",
                  type: "device",
                  attributes: {
                    registered_at: 12345556565,
                    token: "DEVICE_0001"
                  },
                  relationships: {
                    player: {
                      data: {
                        type: "player",
                        id: "12345"
                      }
                    }
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

          operation :delete do
            key :summary, "Unregisters a device"
            key :description, "Unregisters a device so it can no longer receive "\
                              "notifications"
            key :tags, ["DEVICES"]
            security do
              key :Bearer, []
            end
            parameter do
              key :name, :token
              key :type, :string
              key :in, :query
              key :description, "The device token that should be unregistered"
              key :required, true
            end
            response 204 do
              key :description, "No content"
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
            response 404 do
              key :description, "Not found"
              schema do
                key :type, :string
              end
              example name: JSONAPI::MEDIA_TYPE do
                key :errors, "Not found"
              end
            end
          end
        end

        swagger_schema :Device do
          key :type, :object
          key :required, [:id,
                          :type,
                          :token]
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
              key :enum, ["device"]
            end
            property :attributes do
              key :type, :object
              property :registered_at do
                key :type, :integer
                key :format, :dateTime
                key :description, "The date/time of when the device was registered"
              end
              property :token do
                key :type, :string
                key :description, "The token of the device that was registered"
              end
            end
            property :relationships do
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
                  key :description, "The type of object that is represented"
                  key :enum, ["player"]
                end
              end
            end
          end
        end

        swagger_schema :DeviceInput do
          key :type, :object
          key :required, [:data]
          property :data do
            key :type, :object
            key :required, [:attributes]
            property :attributes do
              key :type, :object
              key :required, [:token]
              property :token do
                key :type, :string
                key :description, "The token of the device to register"
              end
            end
          end
        end

      end
    end
  end
end
