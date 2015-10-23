#!/usr/bin/env ruby

module Vapebot

  module Message

    def self.yep
      true
    end

    def self.parse(socket, line)
      return true
      #if line[0] == ":"
      #  prefix, command, args = line.split($;, 3)
      #  command_str = args.slice(/(:![^\s]+.*)/, 1)
      #  if command_str
      #    socket.puts ""
      #  end
      #end
    end
  end

end

