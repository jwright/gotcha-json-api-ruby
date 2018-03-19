class API::DevicesController < ApplicationController
  def create
    Device.create! device_params.merge(player_id: current_user.id,
                                       registered_at: DateTime.now)

    head :created
  end

  private

  def device_params
    params.require(:data)
          .require(:attributes)
          .permit(:token)
  end
end
