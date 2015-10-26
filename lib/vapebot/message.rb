module Vapebot

  module Message
    def self.parse(socket, line)
      if line[0] == ":"
        if line.split($;, 3).last.include? ":!"
          command, *args = line.slice(/(:![^\s]+.*)/, 1)[2..-1].split
          if command == "info"
            socket.puts "PRIVMSG #testingbotshere :I was born today. I dunno what #{args.join(" ")} is... or are. I still need to get some learnin'. Hello, ##vaperhangout."
          else
            ss = "You entered: (#{command}),  with the arguments: (#{args.join(",")})"
            #TODO fix channel name to be dynamic
            socket.puts "PRIVMSG #testingbotshere :#{ss}"
          end
        end
      end
    end
  end

end

