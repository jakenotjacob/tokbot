require "vapebot/command"
require "vapebot/handler"
require "vapebot/logger"

class Bot
  include Command
  include Handler
  attr_reader :connection
  def initialize
    @connection = Connection.new
    Logger.init(Config[:channels])
  end
  def run
    while line = connection.recv
      [:INT, :TSTP].each do |signal|
        Signal.trap(signal) do
          case signal
          when :INT
            Logger.write_status(Config[:channels], "Closing")
            connection.close
            File.delete('bin/vapebot.pid')
            abort "\nClosing bot..."
          when :TSTP
            puts "\nEnter text to send: "
            input = gets.chomp
            connection.broadcastmsg(input)
          end
        end
      end

      puts line
      #We only care for PRIVMSG, and PING
      if line.scan(/PING/).any?
        connection.pong(line)
      end
      if line.scan(/PRIVMSG/).any?
        source, _, dest, args = line.split(" ", 4)
        msg = Message.new(source, dest, args)
        Logger.log(msg.source, msg.target, msg.args)
        if msg.maybe_cmd?
          say(*route(msg))
        end
      end
    end
  end

  def route(msg)
    handler = find_command(msg.cmd)
    if handler.is_a? Symbol
      response = dispatch(handler, msg.cmd, msg.cmd_args)
    elsif handler.is_a? String
      response = run_command(handler, msg.cmd_args)
    else
      response = Database::Facts.get(msg.cmd)
    end
    return [msg, response]
  end

  def say(msg, response)
    connection.privmsg(msg.target, response)
  end
end
