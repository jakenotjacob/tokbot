$:.unshift File.dirname(__FILE__)
class Person < Plugin
  def execute
    greet
  end

  def greet
    puts "Hello, ima Person!"
  end
end
