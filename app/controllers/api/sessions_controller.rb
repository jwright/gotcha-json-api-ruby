class API::SessionsController < ApplicationController
  def create
    player = Player.authenticate(player_params[:email_address],
                                 player_params[:password])

    if player
      render json: PlayerSerializer.new(player).serialized_json
    else
      raise JSONAPI::UnauthorizedError
    end
  end

  private

  def player_params
    params.require(:data)
          .require(:attributes)
          .permit(:email_address,
                  :password)
  end
end
