require "grimm/orm/database_connector.rb"
require "grimm/orm/queries.rb"
require "sqlite3"

module Grimm
  class GrimmRecord

    def self.to_table(table_name)
      @table = table_name
    end

    def self.property(column_name, args)
      @properties ||= {}
      @properties[column_name] = args
    end

    def self.create_table
      prop_array = []
      @properties.each do |key, value|
        properties ||= []
        properties << key.to_s
        value.each do |name, type|
          properties << send("#{name.downcase}_query", type)
        end
        prop_array << properties.join(" ")
      end
      query = "CREATE TABLE IF NOT EXISTS #{@table} (#{prop_array.join(', ')})"
      DatabaseConnector.execute(query)
      make_methods
    end

    def self.make_methods
      mtds = @properties.keys.map(&:to_sym)
      mtds.each { |mtd| attr_accessor mtd }
    end

    def self.primary_key_query(value = false)
      "PRIMARY KEY AUTOINCREMENT" if value
    end

    def self.autoincrement_query(value = false)
      "AUTOINCREMENT" if value
    end

    def self.nullable_query(value = true)
      "NOT NULL" unless value
    end

    def self.type_query(value)
      value.to_s
    end

    def self.properties_keys
      @properties.keys
    end

    def get_values
      attributes = self.class.properties_keys
      attributes.delete(:id)
      attributes.map { |method| send(method) }
    end

    def update_records_placeholders
      columns = self.class.properties_keys
      columns.delete(:id)
      columns.map { |col| "#{col}=?" }.join(",")
    end

    def get_columns
      columns = self.class.properties_keys
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
      properties = self.class.properties_keys
      (["?"] * (properties.size - 1)).join(",")
    end

    def self.map_object(row)
      model_name = new
      @properties.each_key.with_index do |value, index|
        model_name.send("#{value}=", row[index])
      end
      model_name
    end
  end
end
