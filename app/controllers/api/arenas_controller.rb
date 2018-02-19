class API::ArenasController < ApplicationController
  before_action :require_authorization

  def index
    arenas = Arena.near([params[:latitude], params[:longitude]], 5)
    render json: ArenaSerializer.new(arenas).serialized_json
  end

  def play
    player_arena = PlayerArena.create! player_id: current_user.id,
                                       arena_id: params[:id],
                                       joined_at: DateTime.now
    render json: PlayerArenaSerializer.new(player_arena).serialized_json
  end
end
