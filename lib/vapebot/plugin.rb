module Vapebot
module PluginManager
  def self.plugins
    @plugins ||= {}
  end
  def self.register(klass)
    k_name = klass.to_s.downcase.to_sym
    plugins[k_name] = klass
  end
end


#Create a new plugin by creating Plugin subclass
#and adding it into the plugins directory.
#ie - 'plugins/thing.rb' would contain 'class Thing < Plugin'
class Plugin
  def self.inherited(klass)
    PluginManager.register(klass)
  end

  def execute
  end
end
end

