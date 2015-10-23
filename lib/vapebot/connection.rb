#!/usr/bin/env ruby

require 'socket'


module Vapebot
  class Connection
    attr_accessor :socket
    def initialize(config)
      @socket = TCPSocket.new(config.host, config.port.to_i)
      @stream = []
      sleep 2
      register(config.nick, config.user, config.host, config.pass)
      sleep 3
      join_channel(config.channels)
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

    def listen
      Thread.new {
        while line = @socket.gets.chomp
          @stream << line
          puts line
        end
      }
    end

    #TODO move this
    def handle(command_str)
      cmd, *args = command_str.split
    end

    #TODO move this
    def parse(line)
      _, command_str = line.scan(/(\sPRIVMSG\s.*\s:!)(.*)/).first
      if command_str
        handle(command_str)
      elsif (line[0..3] == "PING")
        @socket.puts "PONG #{line[5..-1]}"
      else
        #Do nothing
      end
    end

  end
end

