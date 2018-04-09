class API::PlayersController < ApplicationController
  include JSONAPI::ActsAsResourceController

  before_action :require_authorization, except: :create

  def show
    player = Player.find params[:id]

    authorize! :read, player, message: "Player could not be found"

    hash = PlayerSerializer.new(player).serializable_hash
    hash[:data][:attributes].delete(:api_key)

    render json: PlayerSerializer.to_json(hash)
  end
end
