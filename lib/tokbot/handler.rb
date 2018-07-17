#Load all the plugins
Dir[__dir__+'/plugins/**/*_plugin.rb'].each {|file| require file }

module Tokbot
  module Handler
    def plugins
      PluginManager.plugins
    end

    def is_plugin?(thing)
      plugins.select { |name, klass|
        #if klass.instance_methods.include? cmd.to_sym
        if name == thing.to_sym
          return name
        end
      }
    end

    def dispatch(plugin, args)
      #plugin and cmd are same thing...
      if args.empty?
        plugins[plugin].new
      else
        plugins[plugin].new(args).execute
      end
    end
  end
end

