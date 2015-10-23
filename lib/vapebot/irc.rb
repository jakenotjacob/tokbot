#!/usr/bin/env ruby
module Vapebot
  module IRC
    module Channel
      def self.join(socket, channels)
        channels.each { |channel|
          socket.puts "JOIN #{channel}"
          socket.puts "PRIVMSG #{channel} :HERE!"
        }
      end

      def self.part(socket, channel)
        socket.puts "PART #{channel}"
      end
    end

    module Server
      #puts "Inside Server module... about to register"
      def self.register(socket, nick, pass)
        #puts "Insider Server(self.register)... about to send msg to socket"
        socket.puts "NICK #{nick}"
        #puts "Send nick to socket..."
        sleep 1
        socket.puts "USER #{nick} 8 * :#{nick}"
        #puts "send user reg line to socket..."
        socket.puts "NICKSERV IDENTIFY #{nick} #{pass}"
        sleep 1
      end

      def self.quit(socket)
        socket.puts "QUIT"
      end
    end
  end
end
