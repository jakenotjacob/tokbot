module Tokbot
class Message
  attr_accessor :args, :cmd, :cmd_args
  attr_reader :source, :target
  def initialize(params)
    @source = params[:source]
    @target = params[:target]
    @args = params[:args]
    @cmd = nil
    @cmd_args = nil
    post_init
  end

  def post_init
    parse_source
    parse_target
  end

  def parse_target
    if @target == Config[:nick]
      @target = @source
    end
  end

  def parse_source
    @source = @source.scan(/\w+/).first
  end

  def maybe_cmd?
    if @args[0..1] == ":!"
      parse_cmd
      return true
    else
      return false
    end
  end

  def user_mentioned
    if (@cmd_args[0] == "|")
      user = @cmd_args[1]
      if !(user.nil?) && !(user.empty?)
        return user
      end
    else
      return nil
    end
  end

  def parse_cmd
    @cmd, *@cmd_args = @args.split
    @cmd = @cmd[2..-1]
  end
end
end

