#!/usr/bin/env ruby

require 'yaml'

module Vapebot
  class Config
    attr_accessor :nick, :user, :channels
    attr_reader :host, :port
    def initialize(config: YAML.load_file(File.join(__dir__, 'config.yaml')))
      @host = config[:host]
      @port = config[:port]
      @nick = config[:nick]
      @user = config[:user]
      @pass = config[:pass]
      @channels = config[:channels]
    end
  end
end

