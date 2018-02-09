class API::PlayersController < ApplicationController
  def create
    player = Player.new player_params
    player.save

    head :created
  end

  private

  def player_params
    params.require(:data)
          .require(:attributes)
          .permit(:avatar,
                  :email_address,
                  :first_name,
                  :last_name,
                  :password)
  end
end
