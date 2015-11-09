require 'socket'

module Irc
  class Connection
    attr_accessor :socket
    def initialize
      @socket = TCPSocket.open(Config[:server], Config[:port].to_i)
      post_init
    end

    def post_init
      register
      join_channel
    end

    def register
      send_pass
      send_nick
      send_user
    end

    def send(msg)
      @socket.puts msg
    end

    def recv
      @socket.gets.chomp
    end

    def privmsg(target, msg)
      send "PRIVMSG #{target} :#{msg}"
    end

    def send_pass
      if Config[:password]
        send "PASS #{Config[:password]}"
      end
    end

    def send_nick
      send "NICK #{Config[:nick]}"
    end

    def send_user
      send "USER #{Config[:nick]} 8 * :#{Config[:user]}"
    end

    def join_channel
      send "JOIN #{Config[:channel]}"
    end

    def stop
      @socket.close
    end
  end
end

