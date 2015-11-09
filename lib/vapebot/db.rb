require 'sdbm'

FACTS = "data/facts"
REQUESTS = "data/requests"

module Db
  module Facts
    def self.add(name, reply)
      SDBM.open(FACTS) do |fact|
        fact[name] = reply
      end
      "Fact #{name} added."
    end

    def self.get(name)
      SDBM.open(FACTS) do |fact|
        if fact[name] != nil
          fact[name]
        end
      end
    end

    def self.remove(name)
      SDBM.open(FACTS) do |fact|
        fact.delete(name)
      end
      "Fact #{name} removed."
    end

    def self.keys
      SDBM.open(FACTS) do |fact|
        fact.keys
      end
    end
  end

  module Requests
    def self.add(name, request)
      SDBM.open(REQUESTS) do |req|
        if req[name]
          "The name of this feature request exists. Please choose another (or tack on a number)."
        else
          req[name] = request
          "Feature request added!"
        end
      end
    end
  end

end

