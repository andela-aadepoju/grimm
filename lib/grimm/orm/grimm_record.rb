require "sqlite3"

module Grimm
  class GrimmRecord
    @@properties = {}
    @@table = nil

    def self.to_table(table_name)
      @@table = table_name
    end

    def self.property(column_name, args)
      @@properties[column_name] = args
    end

    def self.create_table
      prop_array = []
      @@properties.each do |key, value|
        properties = []
        properties << key.to_s
        value.each do |name, type|
          get_table_query(properties, name, type)
        end
        prop_array << properties.join(" ")
      end
      query = "CREATE TABLE IF NOT EXISTS #{@@table} (#{prop_array.join(', ')})"
      DatabaseConnector.execute(query)
      make_methods
    end

    def self.make_methods
      mtds = @@properties.keys.map(&:to_sym)
      instance_exec(mtds) do
        mtds.each { |mtd| attr_accessor mtd }
      end
    end

    def self.get_table_query(properties, name, type)
      name = name.to_s.downcase
      if name == "primary_key" && type
        properties << "PRIMARY KEY AUTOINCREMENT"
      elsif name == "autoincrement" && type
        properties << "AUTOINCREMENT"
      elsif name == "nullable" && !type
        properties << "NOT NULL"
      elsif name == "type"
        properties << type.to_s
      end
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

    def self.find(id)
      row = DatabaseConnector.execute("SELECT #{@@properties.keys.join(',')}
      FROM #{@@table} WHERE id = ?", id).first
      map_object(row)
    end

    def get_values
      attributes = @@properties.keys
      attributes.delete(:id)
      attributes.map { |method| send(method) }
    end

    def update_records_placeholders
      columns = @@properties.keys
      columns.delete(:id)
      columns.map { |col| "#{col}=?" }.join(",")
    end

    def get_columns
      columns = @@properties.keys
      columns.delete(:id)
      columns.join(",")
    end

    def update_records
      get_values << send(:id)
    end

    def new_record_value
      get_values
    end

    def new_record_placeholders
      (["?"] * (@@properties.size - 1)).join(",")
    end

    def self.map_object(row)
      model_name = new
      @@properties.each_key.with_index do |value, index|
        model_name.send("#{value}=", row[index])
      end
      model_name
    end

    def self.findAll
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
  end
end
