require 'socket'

module Vapebot
  class Connection
    attr_accessor :socket, :stream
    def initialize(config)
      @socket = TCPSocket.new(config.host, config.port.to_i)
      @stream = []
      IRC::Server::register(@socket, config.nick, config.pass)
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
      while line = receive()
        if line[0..3] == "PONG"
          keepalive(line)
          puts "--------------HAD TO KEEP ALIVE!!!----------------"
        end
        @stream << line
        Vapebot::Message.parse(@socket, line)
      end
    end

  end
end

