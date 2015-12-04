module Vapebot
class Connection
  include IRC
  attr_accessor :socket
  def initialize
    @socket = TCPSocket.open(Config[:server], Config[:port].to_i)
    post_init
  end

  def post_init
    register
    sleep 2
    join_channels
  end

  def send(msg)
    @socket.puts msg
  end

  def recv
    @socket.gets.chomp
  end

  def close
    send "QUIT"
    @socket.close
  end
end
end

