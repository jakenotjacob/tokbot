require 'sequel'

module Database
  DB = if File.exists? "data/vapebot.db"
         Sequel.sqlite("data/vapebot.db")
       else
         puts "Error! Database has not yet been created!".red
         abort("Please run `rake db:create` then retry.")
       end

  module Facts
    FACTS = DB[:facts]
    def self.add(args)
      name, definition = args
      begin
        if FACTS.insert(name: name, definition: definition)
          return "Fact added."
        else
          return "Fact not added."
        end
      rescue Sequel::UniqueConstraintViolation
        "Fact with that name or definition already exists."
      rescue Sequel::NotNullConstraintViolation
        "A fact needs a definition!"
      end
      #Returns ID on success
      #Return NIL on already-existant name
    end

    def self.get(args)
      name = args
      if FACTS[name: name]
        FACTS[name: name][:definition]
      else
        "Fact does not exist. Use !help to see available facts."
      end
      #Returns HASH on existant
      #Returns NIL on non-existant
    end

    def self.update(args)
      name, definition = args
      begin
        if FACTS.where(name: name).update(definition: definition)
          "Fact updated."
        end
      rescue Sequel::UniqueConstraintViolation
        "Fact with that name or definition already exists."
      rescue Sequel::NotNullConstraintViolation
        "A fact needs a definition!"
      end
    end

    def self.remove(args)
      name = args
      if FACTS[name: name]
        FACTS.where(name: name).delete
        "Fact removed."
      else
        "Cannot remove fact that doesn't exist!"
      end
      #Return 1 on success
      #Return 0 on non-exist
    end

    def self.list
      fact_list = []
      FACTS.each do |f|
        fact_list << f[:name]
      end
      return fact_list.sort_by {|name| name.downcase}.join(" ")
    end
  end

end

