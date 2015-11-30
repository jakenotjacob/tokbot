require "vapebot/plugin"
#NOTE! __dir__ does not exist in rubies prior to 2.0
Dir[__dir__ + '/plugins/*.rb'].each {|file| require file }


module Handler
  def plugins
    PluginManager.plugins
  end

  def dispatch(cmd)
    plugins.each { |k, v|
      if v.instance_methods.include? cmd.to_sym
        v.new.send cmd.to_sym
      end
    }
  end
end

