module Irc
  class Bot
    attr_accessor :server
    def initialize
      @connection = Connection.new
      @msg = nil
    end

    def run
      while line = @connection.recv
        puts line
        #We only care for PRIVMSG, and PING
        if line.scan(/PING/).any?
          _, server = line.split(" ")
          @connection.send "PONG #{server}"
        end
        if line.scan(/PRIVMSG/).any?
          source, cmd, dest, args = line.split($;, 4)
          msg = Message.new(source, cmd, dest, args)
          if msg.maybe_fact?
            msg.parse_fact
            send(*handle(msg))
          end
        end
      end
    end

    AUTH = %w(agent_white cyberfawkes tomflint Symmetry)
    def handle(msg)
      case msg.fact
      when "add"
        if AUTH.include? msg.source
          response = Db::Facts.add(msg.fact_args[0], msg.fact_args[1])
        else
          send(msg, "You are not authorized to perform this action.")
        end
      when "remove"
        if AUTH.include? msg.source
          response = Db::Facts.remove(msg.fact_args[0])
        else
          send(msg, "You are not authorized to perform this action.")
        end
      when "help"
        response = "Here are vapebot's available commands --> " + Db::Facts.keys.sort_by{|f|f.downcase}.join(", ")
      when "request"
        response = Db::Requests.add(msg.fact_args[0], msg.fact_args[1])
      when "wtf"
        response = "What the hell is #{msg.fact_args[0]}?"
      else
        response = Db::Facts.get(msg.fact)
      end
      return [msg, response]
    end

    def send(msg, response)
      @connection.privmsg(msg.target, response)
    end

  end
end

