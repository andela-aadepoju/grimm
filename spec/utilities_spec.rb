require 'spec_helper'


describe Grimm do
  it "Makes string Camel Case" do
    expect("camel_case".camelcase).to eql "camelcase"
  end

  it "Makes string Snake Case" do
    expect("SnakeCase".snake_case).to eql "snake_case"
  end
end
