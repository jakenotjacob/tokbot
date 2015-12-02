$:.unshift File.dirname(__FILE__)
class Person < Plugin
  def execute
    greet
  end

  def greet(name)
    "Hello, my name is #{name.join(" ")}!"
  end
end
