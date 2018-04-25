class ConfirmCaptureNotifier
  include PushNotificationNotifier

  attr_reader :match

  def initialize(match)
    @match = match
  end

  def notify_player!(player)
    notifications_for(player).compact.each do |notification|
      client.push notification
    end
  end

  private

  def notification(player, token)
    if opponent = match.opponent_for(player)
      notification = Houston::Notification.new(device: token)
      notification.alert = "Gotcha! Looks like you met #{opponent.name}. "\
                           "Please confirm with his code."
      notification.category = :confirm_capture
      notification.badge = Match.for(player).open.count
      notification.custom_data = MatchSerializer.new(match).serializable_hash
      notification
    end
  end
end
