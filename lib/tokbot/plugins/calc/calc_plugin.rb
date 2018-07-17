class Calc < Tokbot::Plugin
  def initialize(args)
    foo, bar = args
  end

  def self.new(args=nil)
    if args
      super
    else
      "Enter watts, volts, or ohms in a two-pair to calculate."
    end
  end

end
