module Command
  DB_DISPATCH = {
    facts: {
      add: "Database::Facts.add",
      update: "Database::Facts.update",
      remove: "Database::Facts.remove",
      help: "Database::Facts.list"
    },
    users: {
      useradd: "Database::Users.add",
      useradmin: "Database::Users.grant_admin",
      isadmin: "Database::Users.is_admin?"
    }
  }

  def span(table, cmd)
    table.map { |group, hash|
      hash.map do |key, val|
        val if key == cmd.to_sym
      end
    }.flatten.compact.first
  end

  def lookup(cmd)
    span(DB_DISPATCH, cmd)
  end
end
