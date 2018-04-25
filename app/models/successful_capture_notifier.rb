class SuccessfulCaptureNotifier
  include PushNotificationNotifier

  attr_reader :match

  def initialize(match)
    @match = match
  end

  def notify!
    notify_player!(match.seeker)
    notify_player!(match.opponent)
  end

  def notify_player!(player)
    notifications_for(player).each do |notification|
      client.push notification unless notification.nil?
    end
  end

  private

  def notification(player, token)
    if opponent = match.opponent_for(player)
      notification = Houston::Notification.new(device: token)
      notification.alert = "Gotcha! You just met #{opponent.name}!"
      notification.category = :successful_capture
      notification.badge = Match.for(player).open.count
      notification.custom_data = MatchSerializer.new(match).serializable_hash
      notification
    end
  end
end
