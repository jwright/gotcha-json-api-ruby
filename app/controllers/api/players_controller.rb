class API::PlayersController < ApplicationController
  include JSONAPI::ActsAsResourceController

  before_action :require_authorization, except: :create

  def create
    player = Player.create! player_params.merge(api_key: TokenGenerator.generate)

    render json: PlayerSerializer.new(player).serialized_json,
           status: :created
  end

  def show
    player = Player.find params[:id]

    authorize! :read, player, message: "Player could not be found"

    hash = PlayerSerializer.new(player).serializable_hash
    hash[:data][:attributes].delete(:api_key)

    render json: PlayerSerializer.to_json(hash)
  end

  private

  def player_params
    params.require(:data)
          .require(:attributes)
          .permit(:avatar,
                  :email_address,
                  :name,
                  :password)
  end
end
