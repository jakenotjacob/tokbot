module Vapebot
module IRC
  def register
    send_nick
    send_user
    send_pass
  end

  def send_pass
    if Config[:password]
      send "NICKSERV IDENTIFY #{Config[:password]}"
    end
  end

  def send_nick
    send "NICK #{Config[:nick]}"
  end

  def send_user
    send "USER #{Config[:nick]} 8 * :#{Config[:user]}"
  end

  def pong(line)
    _, server = line.split(" ")
    send "PONG #{server}"
  end

  def join_channels
    Config[:channels].each do |chan|
      send "JOIN #{chan}"
    end
  end

  def privmsg(target, msg)
    send "PRIVMSG #{target} :#{msg}"
  end

  def notice(target, error)
    case error
    when :unknown
      send "NOTICE #{target} :Unknown command. Use !help to see available commands."
    end
  end

  def broadcastmsg(msg)
    if msg.is_a? Array
      msg = msg.join(" ")
    end
    Config[:channels].each do |chan|
      privmsg(chan, msg)
    end
  end
end
end

