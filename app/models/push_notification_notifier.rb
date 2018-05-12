require "houston"

module PushNotificationNotifier
  private

  def client
    @client ||=Houston::Client.development
=begin
    @client ||= Houston::Client.respond_to?(Rails.env) ?
                  Houston::Client.send(Rails.env) :
                  Houston::Client.new
=end
  end

  def notifications_for(player)
    Device.for(player).map { |device| notification(player, device.token) }
  end

  def notification(player, token)
    raise NotImplementedError, "Class must implement the notification"
  end
end
