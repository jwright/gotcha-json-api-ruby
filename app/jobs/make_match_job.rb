class MakeMatchJob < ApplicationJob
  queue_as :default

  def perform(player_id, arena_id)
    # Do something later
  end
end
