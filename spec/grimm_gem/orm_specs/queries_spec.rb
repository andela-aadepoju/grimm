require "spec_helper"
describe "Grimm Record Queries"do

  it " deletes all rows in a table" do
    sleep 1
    create_posts
    expect(Post.delete_all).to eq []
  end

  it "returns the first item in the database" do
    sleep 1
    create_posts
    expect(Post.first).to include "list body"
  end

  it "returns the last item in the database" do
    sleep 1
    create_second_posts
    expect(Post.last).to include "Second Post body"
  end

  it "returns the latest item in the database" do
    create_posts
    sleep 1
    create_second_posts
    expect(Post.latest.first.body).to eql "Second Post body"
  end

  it "returns all item in the database" do
    create_posts
    sleep 1
    create_second_posts
    expect(Post.all.first.body).to eql "list body"
  end

  it "deletes items from the database" do
    create_second_posts
    sleep 1
    create_posts
    id = Post.latest.first.id
    expect(Post.delete(id)).to eql []
  end

  it "finds items from the database by id" do
    create_posts
    sleep 2
    create_second_posts
    id = Post.all.first.id
    expect(Post.find(id).title).to include "Title to post"
  end
end
