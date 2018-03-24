require "houston"

class MatchNotifier
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

  def client
    @client ||= Houston::Client.respond_to?(Rails.env) ?
                  Houston::Client.send(Rails.env) :
                  Houston::Client.new
  end

  def notifications_for(player)
    Device.for(player).map { |device| notification(player, device.token) }
  end

  def notification(player, token)
    if opponent = match.opponent_for(player)
      notification = Houston::Notification.new(device: token)
      notification.alert = "Gotcha! #{opponent.name} is out to get 'cha!"
      notification.badge = Match.for(player).open.count
      notification.custom_data = {}
      notification
    end
  end
end
