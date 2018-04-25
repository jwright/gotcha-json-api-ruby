class SuccessfulCaptureJob < ApplicationJob
  queue_as :default

  def perform(match_id)
    match = Match.find match_id

    if match.found?
      Score.captured_player!(match.arena, match.seeker)
      Score.captured_player!(match.arena, match.opponent)
      SuccessfulCaptureNotifier.new(match).notify!
    end

  rescue ActiveRecord::RecordNotFound => e
    logger.error e
  end
end
