class Message
  attr_accessor :source, :target, :args, :fact, :fact_args
  def initialize(source, target, args)
    @source = parse_source(source)
    @target = parse_target(target)
    @args = args
    @fact = nil
    @fact_args = nil
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

  def maybe_fact?
    puts "Found args... #{args}"
    if args[0..1] == ":!"
      parse_fact
      return true
    else
      return false
    end
  end

  def parse_fact
    @fact, *@fact_args = args.split(" ", 3)
    @fact = @fact[2..-1]
  end
end

