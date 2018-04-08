class API::PlayersController < ApplicationController
  def create
    player = Player.create! player_params.merge(api_key: TokenGenerator.generate)

    render json: PlayerSerializer.new(player).serialized_json,
           status: :created
  end

  def show
    player = Player.find params[:id]

    render json: PlayerSerializer.new(player).serialized_json
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
