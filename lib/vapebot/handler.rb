require "vapebot/plugin"
#NOTE! __dir__ does not exist in rubies prior to 2.0
Dir[__dir__ + '/plugins/*.rb'].each {|file| require file }


module Handler
  def plugins
    PluginManager.plugins
  end

  def get_handler(cmd)
    plugins.each { |name, klass|
      if klass.instance_methods.include? cmd.to_sym
        return name
      else
        return nil
      end
    }
  end

  def dispatch(plugin, cmd, args)
    if args.empty?
      plugins[plugin].new.send cmd.to_sym
    else
      plugins[plugin].new.send cmd.to_sym, args
    end
  end
end

