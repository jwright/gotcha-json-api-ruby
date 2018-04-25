class API::ScoresController < ApplicationController
  before_action :require_authorization

  def index
    scores = score_params[:filter].nil? ?
      Score.playable_by(current_user) :
      Score.where(score_params[:filter])

    # NOTE: There is a security issue here where anyone can find the
    # scores of anyone in any arena

    meta = { total_points: scores.sum(&:points) }

    if scores.map(&:arena_id).uniq.count == 1 &&
       scores.map(&:player_id).uniq.count == 1
      arena = scores.first.arena
      player = scores.first.player
      placement = Placement.new(arena).ordinal_for(player)
      meta.merge!(placement: placement)
    end

    render json: ScoreSerializer.new(scores, { meta: meta }).serialized_json
  end

  private

  def score_params
    params.permit(:filter)
  end
end
