module IRC
  def register
    send_pass
    send_nick
    send_user
  end

  def send_pass
    if Config[:password]
      send "PASS #{Config[:password]}"
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

  def broadcastmsg(msg)
    Config[:channels].each do |chan|
      privmsg(chan, msg)
    end
  end
end

