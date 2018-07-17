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
    while input = connection.recv
      puts input
      #We only care for PRIVMSG, and PING
      if input.scan(/PING/).any?
        connection.pong(input)
      end
      if input.scan(/PRIVMSG/).any?
        msg = Message.new(sanitize(input))
        if msg.maybe_cmd?
          handle(msg)
        end
      end
    end
  end

  def sanitize(input)
    source, _, target, args = input.split(" ", 4)
    Logger.log(source, target, args)
    return {source: source, target: target, args: args}
  end

  def handle(msg)
    response = route(msg)
    if user = msg.user_mentioned
      response.prepend("#{user}: ")
    end
    if response && response.not_empty?
      connection.privmsg(msg.target, response)
    else
      connection.notice(msg.source, :unknown)
    end
  end

  def route(msg)
    handler = is_plugin?(msg.cmd)
    if !handler.empty?
      response = dispatch(handler, msg.cmd_args)
    else
      if Database::Users.is_admin?(msg.source)
        handler = get_command(msg.cmd)
        if handler
          response = run_command(handler, msg.cmd_args)
        else
          response = Database::Facts.get(msg.cmd)
        end
      else
        response = Database::Facts.get(msg.cmd)
      end
    end
    return response
  end

end
end

