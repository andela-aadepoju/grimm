require "spec_helper"
describe "grimm record" do
  describe "#create_table_query" do
    it "returns creat query hash as string" do
      auto = ["AUTOINCREMENT"]
      expect(List.get_table_query([], "autoincrement", "ture")).to eq auto
    end

    it " deletes all rows in a table" do
      expect(List.delete_all).to eq []
    end

    it "instantiates table name" do
      expect(List.to_table("lists")).to eq "lists"
    end

    it "returns a hash of properties" do
      expect(List.property(:id, type: :integer)).to be_an_instance_of(Hash)
    end

    it "returns symbols of properties keys" do
      expect(List.make_methods).to eq [:id, :title, :body, :created_at, :done]
    end

    it "returns value of primary key" do
      primary = ["PRIMARY KEY AUTOINCREMENT"]
      expect(List.get_table_query([], "primary_key", true)).to eq primary
    end

    it "returns value of nullable" do
      expect(List.get_table_query([], "nullable", false)).to eq ["NOT NULL"]
    end

    it "returns value of row type" do
      expect(List.get_table_query([], "type", true)).to eq ["true"]
    end

    it "returns the first item in the database" do
      expect(List.first).to be_kind_of Array
    end

    it "returns the last item in the database" do
      expect(List.last).to be_kind_of Array
    end
  end
end
