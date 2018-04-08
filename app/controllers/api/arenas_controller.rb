class API::ArenasController < ApplicationController
  before_action :require_authorization

  def index
    arenas = Arena.near([params[:latitude], params[:longitude]], 5)
    render json: ArenaSerializer.new(arenas).serialized_json
  end

  def leave
    arena = Arena.find params[:id]
    player_arena = PlayerArena.find_by player_id: current_user.id, arena: arena
    raise ActiveRecord::RecordNotFound, "Player not found in Arena" if player_arena.nil?
    player_arena.destroy!

    head :no_content
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

    MakeMatchJob.perform_later player_arena.player_id, player_arena.arena_id

    render json: ArenaSerializer.new(arena).serialized_json,
           status: status
  end

  def scores
    arena = Arena.find params[:id]
    scores = Score.for(current_user).in(arena)

    options = { meta: { total_points: scores.sum(&:points) }}
    render json: ScoreSerializer.new(scores, options).serialized_json
  end
end
