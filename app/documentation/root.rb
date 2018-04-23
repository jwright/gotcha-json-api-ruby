require "jsonapi"
require "swagger/blocks"
require_relative "arenas"
require_relative "devices"
require_relative "matches"
require_relative "players"
require_relative "scores"
require_relative "sessions"

module Documentation
  module Root
    def self.included(base)
      base.send :include, Swagger::Blocks
      base.send :include, Arenas
      base.send :include, Devices
      base.send :include, Matches
      base.send :include, Players
      base.send :include, Scores
      base.send :include, Sessions

      base.class_eval do
        swagger_schema :Error do
          key :type, :object
          property :code do
            key :type, :integer
            key :description, "A numeric code that represents the error"
          end
          property :detail do
            key :type, :string
            key :description, "The full error message"
          end
          property :source do
            key :type, :object
            property :pointer do
              key :type, :string
              key :description, "The path in the response that represents the field which caused the error"
            end
          end
          property :status do
            key :type, :integer
            key :description, "The HTTP status code for the errors"
          end
          property :title do
            key :type, :string
            key :description, "The detail of the error message without the field"
          end
        end

        swagger_root do
          key :swagger, "2.0"
          key :schemes, ["http"]
          key :host, "staging.gotcha.run"
          key :basePath, "/api"
          key :consumes, [JSONAPI::MEDIA_TYPE]
          key :produces, [JSONAPI::MEDIA_TYPE]
          info do
            key :version, "0.0.1"
            key :title, "Gotcha API"
            key :description, "The API that runs the Gotcha application."
            contact do
              key :name, "Jamie Wright"
              key :email, "jamie@brilliantfantastic.com"
            end
            license do
              key :name, "MIT"
            end
          end
          security_definition :Bearer do
            key :type, :apiKey
            key :name, :Authorization
            key :in, :header
            key :description, "API key specified in the Authorization "\
                              "request header as a Bearer token"
          end
          tag name: "ARENAS" do
            key :description, "Arena operations"
          end
          tag name: "DEVICES" do
            key :description, "Device operations"
          end
          tag name: "MATCHES" do
            key :description, "Match operations"
          end
          tag name: "PLAYERS" do
            key :description, "Player operations"
          end
          tag name: "SCORES" do
            key :description, "Score operations"
          end
          tag name: "SESSIONS" do
            key :description, "Session operations"
          end
        end
      end
    end
  end
end
