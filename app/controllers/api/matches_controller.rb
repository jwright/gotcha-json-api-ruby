class API::MatchesController < ApplicationController
  def create
    arena = Arena.find match_params[:arena_id]
    MatchMaker.match! player: current_user, arena: arena

    head :created
  end

  private

  def match_params
    params.require(:data)
          .require(:attributes)
          .permit(:arena_id)
  end
end
