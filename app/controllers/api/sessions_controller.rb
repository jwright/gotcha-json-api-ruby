class API::SessionsController < ApplicationController
  def create
    player = Player.authenticate(player_params[:email_address],
                                 player_params[:password])

    if player
      player.generate_api_key!(false)

      render json: PlayerSerializer.new(player).serialized_json
    else
      raise JSONAPI::UnauthorizedError
    end
  end

  def destroy
    current_user.update_attributes! api_key: nil

    head :no_content
  end

  private

  def player_params
    params.require(:data)
          .require(:attributes)
          .permit(:email_address,
                  :password)
  end
end
