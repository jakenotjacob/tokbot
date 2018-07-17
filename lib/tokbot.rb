#Third party
require 'colorize'
require 'sequel'
require 'yaml'

#stdlib
require 'socket'

#helpers
require "tokbot/helpers"

require "tokbot/version"
require "tokbot/trap"

require "tokbot/plugin"
require "tokbot/handler"
require "tokbot/command"

require "tokbot/bot"
require "tokbot/irc"
require "tokbot/connection"
require "tokbot/message"
require "tokbot/db"
require "tokbot/logger"

module Tokbot
  Config = YAML.load_file "config/config.yaml"
end

