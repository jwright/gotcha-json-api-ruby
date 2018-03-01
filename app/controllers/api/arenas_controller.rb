class API::ArenasController < ApplicationController
  before_action :require_authorization

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

  def index
    arenas = Arena.near([params[:latitude], params[:longitude]], 5)
    render json: ArenaSerializer.new(arenas).serialized_json
  end

  def play
    arena = Arena.find params[:id]

    player_arena = PlayerArena.find_by player_id: current_user.id, arena: arena
    if player_arena.nil?
      player_arena = PlayerArena.create! player_id: current_user.id,
                                         arena: arena,
                                         joined_at: DateTime.now
      status = :created
    else
      status = :ok
    end

    render json: PlayerArenaSerializer.new(player_arena).serialized_json,
           status: status
  end
end
