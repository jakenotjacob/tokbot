require "vapebot/command"

class Bot
  include Command
  attr_reader :connection
  def initialize
    @connection = Connection.new
  end

  def run
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
          send(*handle(msg))
        end
      end
    end
  end

  def handle(msg)
    handler = lookup(msg.cmd)
    if msg.cmd == "help"
      response = eval "#{handler}"
    elsif handler
      response = eval "#{handler} #{msg.cmd_args}"
    else
      response = Database::Facts.get(msg.cmd)
    end
    return [msg, response]
  end

  def send(msg, response)
    connection.privmsg(msg.target, response)
  end

end

