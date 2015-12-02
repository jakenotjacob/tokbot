require "vapebot/plugin"
#NOTE! __dir__ does not exist in rubies prior to 2.0
Dir[__dir__ + '/plugins/*.rb'].each {|file| require file }


module Handler
  def plugins
    PluginManager.plugins
  end

  def get_handler(cmd)
    plugins.each { |k, v|
      if v.instance_methods.include? cmd.to_sym
        return k
      else
        return nil
      end
    }
  end

  def dispatch(plugin, cmd)
    plugins[plugin].new.send cmd.to_sym
  end
end

