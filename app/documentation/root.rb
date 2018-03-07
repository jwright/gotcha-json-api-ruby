require "jsonapi"
require "swagger/blocks"
require_relative "arenas"
require_relative "players"

module Documentation
  module Root
    def self.included(base)
      base.send :include, Swagger::Blocks
      base.send :include, Arenas
      base.send :include, Players

      base.class_eval do
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
          tag name: "PLAYERS" do
            key :description, "Player operations"
          end
        end
      end
    end
  end
end
