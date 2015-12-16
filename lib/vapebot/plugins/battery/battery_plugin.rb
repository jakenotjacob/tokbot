require_relative "model"
class Battery < Vapebot::Plugin
  attr_reader :info
  def initialize(args)
    abbr, attr = args
    abbr.upcase!
    @info = BatteryDB[abbr: abbr]
    post_init()
  end
  def self.new(args=nil)
    if args
      super
    else
      "Available info on batteries: #{BatteryDB.list.join(" ")}"
    end
  end
  def post_init()
      overview
  end

  def execute
    overview
  end

  def overview
    if info
      info.basics
    else
      "wtf is that battery?"
    end
  end

  #def battery(args)
  #  if args
  #    "I got #{args}..."
  #  else
  #    "Usage things..."
  #  end
  #end
end

