#$:.unshift File.dirname(__FILE__)
module Vapebot
module Logger
  def self.init(channels)
    self.create_dirs
    self.write_status(channels, "Opening")
  end

  def self.write_status(channels, status = nil, datetime = Time.new.strftime("%F %T"))
    channels.each { |chan|
      File.open("logs/#{chan.gsub("#","")}.log", "a+") do |f|
        f.puts "---#{status} Log #{datetime}---\n"
      end
    }
  end

  def self.create_dirs
    %w(logs logs/private).each do |dir|
      Dir.mkdir dir unless Dir.exist? dir
    end
    return true
  end

  def self.stop_log(channel) ##for now, debugging
    puts "CLOSING LOG"
    datetime = Time.now.strftime("%F %T")
    File.open("logs/testing.log}", "a+") do |f|
      f.write("---Logging Stopped #{datetime}---")
    end
  end

  def self.log(user, dest, message)
    datetime = Time.now.strftime("%F %T")
    message = message[1..-1]
    if dest.include? "#"
      chan = dest.gsub("#", "")
      File.open("logs/#{chan}.log", "a+") do |f|
        f.write("#{datetime} <#{user}> #{message}\n")
      end
    else
      File.open("logs/private/#{dest}.log", "a+") do |f|
        f.write("#{datetime} <#{dest}> #{message}\n")
      end
    end
  end
end
end

