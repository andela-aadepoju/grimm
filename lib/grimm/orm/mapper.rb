require "sqlite3"
module Grimm
  class Mapper
    @@db = SQLite3::Database.new File.join "db", "grimm.db"

    @@table_name = self.to_s.split.last
    @@model = nil
    @@mappings = {}

    def save(model_name)
      @model = model_name
      if model_name.id
        @@db.execute(<<SQL, update_records)
UPDATE "#{@@table_name}"
SET
#{update_records_placeholders}
WHERE id = ?
SQL
      else
        @@db.execute "INSERT INTO #{@@table_name} (#{get_columns}) VALUES  (#{new_record_placeholders})", new_record_value
      end
    end

    def self.find(id)
      row = @@db.execute("SELECT #{@@mappings.keys.join(',')} FROM #{@@table_name} WHERE id = ?", id).first
      self.map_object(row)
    end

    def get_values
      attributes = @@mappings.values
      attributes.delete(:id)
      attributes.map { |method| self.send(method) }
    end

    def update_records_placeholders
      columns = @@mappings.keys
      columns.delete(:id)
      columns.map { |col| "#{col}=?" }.join(",")
    end

    def get_columns
      columns = @@mappings.keys
      columns.delete(:id)
      columns.join(",")
    end

    def update_records
      get_values << self.send(:id)
    end

    def new_record_value
      get_values
    end

    def new_record_placeholders
      (["?"] * (@@mappings.size - 1)).join(",")
    end

    def method_missing(method, *args)
      @model.send(method)
    end

    def self.map_object(row)
      model_name = @@model.new
      @@mappings.each_value.with_index do |value, index|
        model_name.send("#{value}=", row[index])
      end
        model_name
    end

    def self.findAll
      data = @@db.execute "SELECT #{@@mappings.keys.join(',')} FROM #{@@table_name}"
      data.map do |row|
        self.map_object(row)
      end
    end

    def delete(id)
      @@db.execute "DELETE FROM #{@@table_name} WHERE id = ?", id
    end

  end
end
