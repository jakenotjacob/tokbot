#!/usr/bin/env ruby

module Vapebot
  class Bot
    attr_accessor :config, :connection
    def initialize()
      @config = Vapebot::Config.new
      @connection = Vapebot::Connection.new(@config)
    end

    def run
    end
  end
end