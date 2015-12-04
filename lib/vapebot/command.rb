module Vapebot
module Command
  COMMANDS = {
    #channels: {
      #broadcast: "Connection.broadcastmsg",
    #},
    facts: {
      add: "Database::Facts.add",
      update: "Database::Facts.update",
      remove: "Database::Facts.remove",
      help: "Database::Facts.list"
    },
    users: {
      useradd: "Database::Users.add",
      userdel: "Database::Users.delete",
      userlist: "Database::Users.list",
      giveadmin: "Database::Users.grant_admin",
      isadmin: "Database::Users.is_admin?"
    }
  }

  def get_command(table, cmd)
    table.map { |group, methods|
      methods.map do |label, method|
        method if label == cmd.to_sym
      end
    }.flatten.compact.first
  end

  def run_command(cmd, args)
    if args.empty?
      eval "#{cmd}"
    else
      eval "#{cmd} #{args}"
    end
  end

  def find_command(cmd)
    if handler = get_command(COMMANDS, cmd)
      return handler
    elsif handler = get_handler(cmd)
      return handler
    else
      return nil
    end
  end

end
end

