#!/usr/bin/env ruby

require 'socket'

module Vapebot
  class Connection
    attr_accessor :socket, :stream
    def initialize(config)
      @socket = TCPSocket.new(config.host, config.port.to_i)
      @stream = []
      sleep 2
      IRC::Server::register(@socket, config.nick, config.pass)
      sleep 3
      IRC::Channel::join(@socket, config.channels)
    end

    def send(message)
      @socket.puts message
    end

    def receive
      @socket.gets.chomp
    end

    def keepalive(msg)
      send("PONG #{msg.split.last}")
    end

    def close
      IRC::Server.quit(@socket)
      @socket.close
    end

    def listen
      Thread.new {
        while line = receive()
          puts line
          if line[0..3] == "PONG"
            keepalive(line)
            puts "--------------HAD TO KEEP ALIVE!!!----------------"
          end
          @stream << line
          #puts line
          #if Vapebot::Message.parse(@socket, line)
          #  puts "YeSssssssssssss"
          #end
        end
      }
    end

  end
end

