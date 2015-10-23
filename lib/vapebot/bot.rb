#!/usr/bin/env ruby

module Vapebot
  class Bot
    attr_accessor :config, :connection
    def initialize()
      @config = Vapebot::Config.new
      @connection = Vapebot::Connection.new(@config)
    end

    def start
      @connection.listen()
      while true
        line = @connection.socket.gets
        puts line
      end
    end
  end
end
