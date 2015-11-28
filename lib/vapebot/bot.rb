class Bot
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
    case msg.cmd
    when "add"
      if Database::Users.is_admin?(msg.source)
        response = Database::Facts.add(msg.cmd_args)
      else
        send(msg, "You are not authorized to perform this action.")
      end
    when "update"
      if Database::Users.is_admin?(msg.source)
        response = Database::Facts.update(msg.cmd_args)
      else
        send(msg, "You are not authorized to perform this action.")
      end
    when "remove"
      if Database::Users.is_admin?(msg.source)
        response = Database::Facts.remove(msg.cmd_args)
      else
        send(msg, "You are not authorized to perform this action.")
      end
    #####
    when "useradd"
      if Database::Users.is_admin?(msg.source)
        response = Database::Users.add(msg.cmd_args)
      else
        send(msg, "You are not authorized to perform this action.")
      end
    when "useradmin"
      if Database::Users.is_admin?(msg.source)
        response = Database::Users.grant_admin(msg.cmd_args)
      else
        send(msg, "You are not authorized to perform this action.")
      end
    when "isadmin"
      if Database::Users.is_admin?(msg.source)
        response = Database::Users.is_admin?(msg.cmd_args)
      else
        send(msg, "You are not authorized to perform this action.")
      end
    when "broadcast"
      if Database::Users.is_admin?(msg.source)
        connection.broadcastmsg(msg.cmd_args.join(" "))
      else
        send(msg, "You are not authorized to perform this action.")
      end
    when "help"
      response = "Here are vapebot's available commands --> " + Database::Facts.list
    when "wtf"
      response = "What the fuck is #{msg.cmd_args.first}?"
    when ""
    else
      response = Database::Facts.get(msg.cmd)
    end
    return [msg, response]
  end

  def send(msg, response)
    connection.privmsg(msg.target, response)
  end

end

