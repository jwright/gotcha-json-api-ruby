class API::DevicesController < ApplicationController
  before_action :require_authorization

  def create
    device = Device.create! device_params.merge(player_id: current_user.id,
                                                registered_at: DateTime.now)

    render json: DeviceSerializer.new(device).serialized_json, status: :created
  end

  private

  def device_params
    params.require(:data)
          .require(:attributes)
          .permit(:token)
  end
end
