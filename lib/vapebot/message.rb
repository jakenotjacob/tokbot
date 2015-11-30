class Message
  attr_accessor :source, :target, :args, :cmd, :cmd_args
  def initialize(source, target, args)
    @source = parse_source(source)
    @target = parse_target(target)
    @args = args
    @cmd = nil
    @cmd_args = nil
  end

  def sparkle
    colors = (31..36).to_a.map{|i| "\x1B[#{i.to_s}m"}.cycle
    @cmd_args = @cmd_args.join(" ").split(//).map{ |c|
      "#{colors.next}#{c}"
    }.join.concat("\x1b[39;49m")
  end

  def parse_target(target)
    if target == "vapebot"
      @target = @source
    else
      @target = target
    end
  end

  def parse_source(source)
    return source.scan(/\w+/).first
  end

  def maybe_cmd?
    puts "Found args... #{args}"
    if args[0..1] == ":!"
      parse_cmd
      return true
    else
      return false
    end
  end

  def parse_cmd
    @cmd, *@cmd_args = args.split(" ", 3)
    @cmd = @cmd[2..-1]
  end
end

