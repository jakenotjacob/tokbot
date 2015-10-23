#!/usr/bin/env ruby

require 'socket'


module Vapebot
  class Connection
    attr_accessor :socket
    def initialize(config)
      @socket = TCPSocket.new(config.host, config.port.to_i)
      puts "Opened connection..."
      sleep 2
      register(config.nick, config.user, config.host, config.pass)
      puts "Registered to nickserv..."
      sleep 3
      join_channel(config.channels)
      puts "Joined channel..."
    end

    def register(nick, user, host, pass)
      @socket.puts "NICK #{nick}"
      sleep 1
      @socket.puts "USER #{nick} 8 * :#{nick}"
      sleep 1
      @socket.puts "NICKSERV IDENTIFY #{pass}"
    end

    def join_channel(channels)
      channels.each { |channel|
        puts channel
        @socket.puts "JOIN #{channel}"
        @socket.puts "PRIVMSG #{channel} :HERE!"
      }
    end

  end
end

