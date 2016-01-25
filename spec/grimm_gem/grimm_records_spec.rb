require "spec_helper"
describe "grimm record" do
  describe "#create_table_query" do
    auto = ["AUTOINCREMENT"]
    it "returns creat query hash as string" do
      expect(List.get_table_query([], "autoincrement", "ture")).to eq auto
    end
  end
end
