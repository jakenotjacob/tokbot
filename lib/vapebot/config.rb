require 'yaml'

module Irc
    Config = YAML.load_file "config/config.yaml"
end

