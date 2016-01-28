require_relative "feature_helper"

describe "create todo lists", type: :feature do
  it "creates a post" do
    visit "/"
    click_on "Create New"
    fill_in "title", with: "Test Todo"
    fill_in "body", with: "Test Todo Body"
    click_on "Create"
    click_on "Test Todo"
    click_on "Grim Todo App"
    expect(page).to have_content "Undone"
  end

  it "deletes a post" do
    visit "/"
    click_on "Create New"
    fill_in "title", with: "Deleted Post"
    fill_in "body", with: "Test Todo Body"
    click_on "Create"
    expect(page).to have_content "Deleted Post"
    click_on "Delete", match: :first
    expect(page).to have_content "Deleted Post"
  end

  it "shows error for undefined page" do
    visit "/adebayo"
    expect(page).to have_content "get /adebayo was not defined in the route.
     Check /config/routes.rb for defined routes"
  end

  it "returns empty for favicon.ico" do
    visit "/favicon.ico"
    expect(page).not_to be nil
  end
end
