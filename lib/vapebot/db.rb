module Vapebot
module Database

  DB = if File.exist? "data/vapebot.db"
         Sequel.sqlite("data/vapebot.db")
       else
         puts "Error! Database has not yet been created!".red
         abort("Please run `rake db:create` then retry.")
       end

  module Users
    USERS = DB[:users]
    def self.add(args)
      username = args
      begin
        if USERS.insert(name: username)
          return "User added."
        else
          return "User not added."
        end
      rescue Sequel::UniqueConstraintViolation
        "User with that name already exists."
      rescue Sequel::NotNullConstraintViolation
        "A user needs a name!"
      end
    end

    def self.delete(args)
      name = args
      if USERS[name: name]
        USERS.where(name: name).delete
        "User deleted."
      else
        "User does not exist."
      end
    end

    def self.list
      user_list = []
      USERS.each do |u|
        user_list << u[:name]
      end
      return user_list.sort_by {|name| name.downcase}.join(" ")
    end

    def self.grant_admin(args)
      username = args.first
      USERS.where(name: username).update(admin: true)
      "#{username} is now an admin."
    end

    def self.is_admin?(args)
      username = args
      if USERS[name: username] && USERS[name: username][:admin]
        return true
      else
        return false
      end
    end
  end

  module Facts
    FACTS = DB[:facts]
    def self.add(args)
      name, *definition = args
      definition = definition.join(" ")
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
    end

    def self.get(args)
      name = args
      if FACTS[name: name]
        FACTS[name: name][:definition]
      elsif name == "help"
        self.list()
      else
        nil
      end
    end

    def self.update(args)
      name, *definition = args
      definition = definition.join(" ")
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
end

