#Third party
require 'colorize'
require 'sequel'
require 'yaml'

#stdlib
require 'socket'

#helpers
require "vapebot/helpers"

require "vapebot/version"
require "vapebot/trap"

require "vapebot/plugin"
require "vapebot/handler"
require "vapebot/command"

require "vapebot/bot"
require "vapebot/irc"
require "vapebot/connection"
require "vapebot/message"
require "vapebot/db"
require "vapebot/logger"

module Vapebot
  Config = YAML.load_file "config/config.yaml"
end

