require 'spec_helper'

describe Grimm::Application do
  let(:app) { Grimm::Application.new }
  before :each do
    allow_message_expectations_on_nil
  end

  it "responds to call" do
    expect(app.respond_to?(:call)).to be true
  end
end
