$LOAD_PATH << File.join(File.dirname(__FILE__), "../../lib")
$LOAD_PATH << File.join(File.dirname(__FILE__), "../features/feature_helper")

require "./lib/grimm/orm/grimm_record.rb"
require "./lib/grimm/orm/queries.rb"
require "./lib/grimm/orm/database_connector.rb"

require "simplecov"
SimpleCov.start
# require "coveralls"
# Coveralls.wear!

class Post < Grimm::GrimmRecord
  to_table :posts
  property :id, type: :integer, primary_key: true
  property :title, type: :text, nullable: false
  property :body, type: :text, nullable: false
  property :created_at, type: :text, nullable: false
  create_table
end

def create_posts
  @post = Post.new
  @post.title = "Title to post"
  @post.body = "list body"
  @post.created_at = Time.now.to_s
  @post.save
end

def create_second_posts
  @post = Post.new
  @post.title = "Title to second post"
  @post.body = "Second Post body"
  @post.created_at = Time.now.to_s
  @post.save
end

module Grimm
  class GrimmRecord
    attr_reader :title, :body, :created_at, :id
    @id = 1
    @title = "Title to second post"
    @body = "Second Post body"
    @created_at = Time.now.to_s
  end
end
