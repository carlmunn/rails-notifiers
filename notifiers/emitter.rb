class Notifiers::Emitter < Notifiers::Base

  def self.init
    self.init_for(type: "emitters")
  end

private
  def self.emit(*args)
    self._debug("Sending notification (#{args.first})")

    ActiveSupport::Notifications.instrument(*args)
  end
end