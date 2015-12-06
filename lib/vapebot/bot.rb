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
end

