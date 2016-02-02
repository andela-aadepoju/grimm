module Grimm
  class GrimmRecord
    def self.find(id)
      row = DatabaseConnector.execute("SELECT #{@@properties.keys.join(',')}
      FROM #{@@table} WHERE id = ?", id).first
      map_object(row)
    end

    def self.all
      data = DatabaseConnector.execute "SELECT #{@@properties.keys.join(',')}
      FROM #{@@table}"
      data.map do |row|
        map_object(row)
      end
    end

    def self.delete(id)
      DatabaseConnector.execute "DELETE FROM #{@@table} WHERE id = ?", id
    end

    def self.delete_all
      DatabaseConnector.execute "DELETE FROM #{@@table}"
    end

    def self.last
      query = "SELECT * FROM #{@@table} ORDER BY id DESC LIMIT 1"
      (DatabaseConnector.execute query).first
    end

    def self.first
      query = "SELECT * FROM #{@@table} ORDER BY id LIMIT 1"
      (DatabaseConnector.execute query).first
    end

    def save
      if id
        DatabaseConnector.execute "UPDATE #{@@table} SET
        #{update_records_placeholders} WHERE id = ?", update_records
      else
        DatabaseConnector.execute "INSERT INTO #{@@table} (#{get_columns})
        VALUES  (#{new_record_placeholders})", new_record_value
      end
    end
  end
end
