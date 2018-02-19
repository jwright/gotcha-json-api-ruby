class API::ArenasController < ApplicationController
  before_action :require_authorization

  def index
    arenas = Arena.near([params[:latitude], params[:longitude]], 5)
    render json: ArenaSerializer.new(arenas).serialized_json
  end

  def play
    arena = Arena.find params[:id]

    player_arena = PlayerArena.find_by player_id: current_user.id, arena: arena
    if player_arena.nil?
      player_arena = PlayerArena.create! player_id: current_user.id,
                                         arena: arena,
                                         joined_at: DateTime.now
      status = :created
    else
      status = :ok
    end

    render json: PlayerArenaSerializer.new(player_arena).serialized_json,
           status: status
  end
end
