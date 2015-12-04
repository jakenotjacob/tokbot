module Trapper
  def trap_signals
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
  end
end
