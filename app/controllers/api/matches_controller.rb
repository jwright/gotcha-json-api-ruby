class API::MatchesController < ApplicationController
  before_action :require_authorization

  def capture
    match = Match.find params[:id]
    authorize! :update, match, message: "Not authorized to play in that Match"
    match.pending!

    MakeMatchJob.perform_later match.seeker_id, match.arena_id
    MakeMatchJob.perform_later match.opponent_id, match.arena_id

    render json: MatchSerializer.new(match).serialized_json
  end

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
