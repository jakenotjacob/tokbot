module Vapebot
module Command
  COMMANDS = {
    #channels: {
      #broadcast: "Connection.broadcastmsg",
    #},
    facts: {
      add: "Database::Facts.add",
      update: "Database::Facts.update",
      remove: "Database::Facts.remove"
    },
    users: {
      useradd: "Database::Users.add",
      userdel: "Database::Users.delete",
      userlist: "Database::Users.list",
      giveadmin: "Database::Users.grant_admin",
      isadmin: "Database::Users.is_admin?"
    }
  }

  def get_command(cmd)
    COMMANDS.map { |group, methods|
      methods.map do |label, method|
        method if label == cmd.to_sym
      end
    }.flatten.compact.first
  end

  def run_command(cmd, args)
    begin
    if args.empty?
      eval "#{cmd}"
    else
      eval "#{cmd} #{args}"
    end
    rescue ArgumentError
      return "Wrong number of arguments."
    end
  end

end
end

