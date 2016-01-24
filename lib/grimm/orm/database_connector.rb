module Grimm
  class DatabaseConnector

    def self.connect_db
      @@db = SQLite3::Database.new File.join "db", "grimm.db"
    end

    def self.execute(query, args =  nil)
      @@db ||= connect_db
      return @@db.execute(query, args) if args
      @@db.execute(query)
    end
  end
end
