class Notifiers::Base

  CONSOLE_OUTPUT = true
  
  def self.init_for(type: )
    self.get_klasses(type: type).each do |klass|
      klass.run
    end
  end

  def self.get_klasses(type: )
    self._debug "Getting #{type} classes to initiate"

    path = self.path_for(type)

    klass_names = klass_names_in(path)

    self._debug "Found #{klass_names.inspect}"
    
    klass_names.map {|file_name| self.const_file_name(type, file_name) }
  end

  def _log(*args)
    self.class._log(*args)
  end

  def _debug(*args)
    self.class._debug(*args)
  end

  def self._log(msg)
    Rails.logger.info("[L] #{msg}")
  end

  def self._debug(msg)
    if CONSOLE_OUTPUT
      puts "\e[32m[D] #{msg} \e[0m"
    else
      Rails.logger.debug("[D] #{msg}")
    end
  end

  def self.path_for(type)
    Rails.root.join("./app/lib/notifiers/#{type}")
  end

  def self.klass_names_in(path)
    Dir.glob("#{path}/*.rb").map do |file|
      File.basename(file).gsub('.rb', '').classify
    end
  end

  def self.const_file_name(type, file_name)
    "Notifiers::#{type.capitalize}::#{file_name}".constantize
  end
end