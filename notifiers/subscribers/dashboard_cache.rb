class Notifiers::Subscribers::DashboardCache < Notifiers::Subscribe
  
  def initialize(event)
    # Used by the children classes
    @_klass = event.payload[:klass]
    @_id    = event.payload[:id]
  end

  def self.run
    _attach_on(Notifiers::Emitters::ActiveRecordCommit::KEY) do |event|
      instance = self.new(event)
      instance.clear_agent
      instance.clear_office_admins
    end
  end

  def clear_agent
    clear("dashboard.agent.#{@_id}.left-menu")
  end

  def clear_office_admins
    Agent.find(@_id).administrators.select(:id).each do |_admin|
      clear("dashboard.admin.#{_admin.id}.left-menu")
    end
  end

private
  def clear(cache_key)
    _log("Clearing cache: #{cache_key}")
    Rails.cache.delete(cache_key)
  end
end