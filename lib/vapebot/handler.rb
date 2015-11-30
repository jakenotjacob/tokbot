require "vapebot/plugin"
Dir["plugins/*.rb"].each { |file| require file }

module Handler
  def plugins
    PluginManager.plugins
  end

  def get_handler(cmd)
    plugins.each { |k, v|
      if v.instance_methods.include? cmd.to_sym
        v.new.send cmd.to_sym
      end
    }
  end
end

