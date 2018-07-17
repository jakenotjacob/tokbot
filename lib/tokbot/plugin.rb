module Tokbot
  module PluginManager
    def self.plugins
      @plugins ||= {}
    end
    def self.register(klass)
      name = klass.to_s.downcase.to_sym
      plugins[name] = klass
    end
  end

  class Plugin
    def self.inherited(klass)
      PluginManager.register(klass)
    end
    def execute
    end
  end
end

