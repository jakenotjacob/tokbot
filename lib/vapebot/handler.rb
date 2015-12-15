#Load all the plugins
Dir[__dir__+'/plugins/**/*_plugin.rb'].each {|file| require file }

module Vapebot
  module Handler
    def plugins
      PluginManager.plugins
    end

    def get_handler(cmd)
      puts "Plugins loaded: #{plugins}"
      plugins.select { |name, klass|
        if klass.instance_methods.include? cmd.to_sym
          return name
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
end

