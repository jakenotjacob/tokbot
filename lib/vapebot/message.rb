module Vapebot
class Message
  attr_accessor :source, :target, :args, :cmd, :cmd_args
  def initialize(source, target, args)
    @source = parse_source(source)
    @target = parse_target(target)
    @args = args
    @cmd = nil
    @cmd_args = nil
  end

  def parse_target(t)
    if t == "vapebot"
      @target = @source
    else
      @target = t
    end
  end

  def parse_source(s)
    return s.scan(/\w+/).first
  end

  def maybe_cmd?
    if @args[0..1] == ":!"
      parse_cmd
      return true
    else
      return false
    end
  end

  def parse_cmd
    @cmd, *@cmd_args = @args.split
    @cmd = @cmd[2..-1]
  end
end
end

