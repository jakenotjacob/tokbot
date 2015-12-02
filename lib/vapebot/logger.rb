$:.unshift File.dirname(__FILE__)
module Logger
  
  def self.is_setup?
    self.create_dirs
  end

  def self.create_dirs
    %w(logs logs/private).each do |dir|
      Dir.mkdir dir unless Dir.exists? dir
    end
    return true
  end

  def self.log(user, dest, message)
    datetime = Time.now.strftime("%F %T")
    user = "<#{user}>"
    message = message[1..-1]
    if dest.include? "#"
      dest.gsub!("#", "")
      File.open("logs/#{dest}.log", "a+") do |f|
        f.write("#{datetime} #{user} #{message}\n")
      end
    else
      File.open("logs/private/#{dest}.log", "a+") do |f|
        f.write("#{datetime} #{dest} #{message}\n")
      end 
    end
  end

end
