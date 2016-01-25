require_relative "feature_helper"

describe "visit all route with get request", type: :feature do
  it "creates a post" do
    visit "/lists/new"
    fill_in "title", with: "Test Todo"
    fill_in "body", with: "Test Todo Body"
    click_on "Create"
    expect(page).to have_content "Undone"
  end
end
