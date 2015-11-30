require "vapebot/command"
require "vapebot/handler"

class Bot
  include Command
  include Handler
  attr_reader :connection
  def initialize
    @connection = Connection.new
  end

  def run
    puts plugins
    while line = connection.recv
      Signal.trap("INT") do
        connection.close
        File.delete('bin/vapebot.pid')
        abort "Closing bot..."
      end

      Signal.trap("TSTP") do
        puts "Enter text to send: "
        input = gets.chomp
        connection.broadcastmsg(input)
      end

      puts line
      #We only care for PRIVMSG, and PING
      if line.scan(/PING/).any?
        connection.pong(line)
      end
      if line.scan(/PRIVMSG/).any?
        source, _, dest, args = line.split(" ", 4)
        msg = Message.new(source, dest, args)
        if msg.maybe_cmd?
          send(*route(msg))
        end
      end
    end
  end

  def route(msg)
    handler = lookup(msg.cmd)
    #Methods without arguments
    if %w(help userlist).include? msg.cmd
      response = eval "#{handler}"
    elsif msg.cmd == "broadcast"
      connection.broadcastmsg(msg.cmd_args.join(" "))
    elsif handler
      #As of now Commands with args are all privledged methods
      if Database::Users.is_admin? msg.source
        response = eval "#{handler} #{msg.cmd_args}"
      else
        response = "You are not authorized to perform this action."
      end
    else
      response = Database::Facts.get(msg.cmd)
    end
    return [msg, response]
  end

  def send(msg, response)
    connection.privmsg(msg.target, response)
  end

end

