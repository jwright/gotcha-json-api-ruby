class API::MatchesController < ApplicationController
  before_action :require_authorization

  def create
    arena = Arena.find match_params[:arena_id]
    authorize! :read, arena, message: "Not authorized to play in that Arena"
    match = MatchMaker.match! player: current_user, arena: arena

    if match
      render json: MatchSerializer.new(match).serialized_json,
             status: :created
    end
  end

  private

  def match_params
    params.require(:data)
          .require(:attributes)
          .permit(:arena_id)
  end
end
