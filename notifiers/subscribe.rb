class Notifiers::Subscribe < Notifiers::Base

  def self.init
    self.init_for(type: "subscribers")
  end

private
  def self._attach_on(notifier_key)

    self._debug("Subscribing to (#{notifier_key})")

    ActiveSupport::Notifications.subscribe(notifier_key) do |*args|

      _event = ActiveSupport::Notifications::Event.new(*args)
      
      Notifiers::Subscribe._debug("Received notification (#{notifier_key}) with payload: #{_event.payload.inspect}")

      yield _event
    end
  end
end