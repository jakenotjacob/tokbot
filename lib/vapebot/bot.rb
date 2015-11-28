class Bot
  def initialize
    @connection = Connection.new
  end

  def run
    while line = @connection.recv

      Signal.trap("INT") do
        @connection.close
        File.delete('bin/vapebot.pid')
        abort "Closing bot..."
      end

      Signal.trap("TSTP") do
        puts "Enter text to send: "
        input = gets.chomp
        @connection.broadcastmsg(input)
      end

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

  AUTH = %w(agent_white cyberfawkes tomflint Symmetry neohaven cdsboy famine)
  def handle(msg)
    case msg.fact
    when "add"
      if AUTH.include? msg.source
        response = Database::Facts.add(msg.fact_args[0], msg.fact_args[1])
      else
        send(msg, "You are not authorized to perform this action.")
      end
    when "update"
      if AUTH.include? msg.source
        response = Database::Facts.update(msg.fact_args[0], msg.fact_args[1])
      else
        send(msg, "You are not authorized to perform this action.")
      end
    when "remove"
      if AUTH.include? msg.source
        response = Database::Facts.remove(msg.fact_args[0])
      else
        send(msg, "You are not authorized to perform this action.")
      end
    when "broadcast"
      if AUTH.include? msg.source
        @connection.broadcastmsg(msg.fact_args.join(" "))
      end
    when "help"
      response = "Here are vapebot's available commands --> " + Database::Facts.list
    when "wtf"
      response = "What the fuck is #{msg.fact_args[0]}?"
    when ""
    else
      response = Database::Facts.get(msg.fact)
    end
    return [msg, response]
  end

  def send(msg, response)
    @connection.privmsg(msg.target, response)
  end

end

