class MatchNotFoundError < RuntimeError; end

class MakeMatchJob < ApplicationJob
  queue_as :default

  rescue_from MatchNotFoundError do
    retry_job wait: 2.minutes
  end

  def perform(player_id, arena_id)
    player = Player.find player_id
    arena = Arena.find arena_id

    return if player.matched_in?(arena)

    match = MatchMaker.match! player: player, arena: arena
    raise MatchNotFoundError if match.nil?
  rescue ActiveRecord::RecordNotFound => e
    logger.error e
  end
end
