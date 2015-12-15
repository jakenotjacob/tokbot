module Vapebot
class Bot
  include Command
  include Handler
  include Trapper

  attr_reader :connection
  def initialize
    @connection = Connection.new
    Logger.init(Config[:channels])
  end

  def run

    Thread.new do
      trap_signals
    end

    while line = connection.recv
      puts line
      #We only care for PRIVMSG, and PING
      if line.scan(/PING/).any?
        connection.pong(line)
      end
      if line.scan(/PRIVMSG/).any?
        source, _, target, args = line.split(" ", 4)
        params = {source: source, target: target, args: args}
        msg = Message.new(params)
        Logger.log(msg.source, msg.target, msg.args)
        if msg.maybe_cmd?
          response = route(msg)
          if user = msg.user_mentioned
            response.last.prepend("#{user}: ")
          end
          if response.last
            say(*response)
          end
        end
      end
    end
  end

  def route(msg)
    handler = get_handler(msg.cmd)
    unless handler.empty?
      puts "Handler found: #{handler}".green
      response = dispatch(handler, msg.cmd, msg.cmd_args)
    end
    return [msg, response]
  end

  def say(msg, response)
    connection.privmsg(msg.target, response)
  end
end
end

