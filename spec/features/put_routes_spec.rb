require_relative "feature_helper"

describe "create todo lists", type: :feature do
  it "marks a post as done" do
    visit "/"
    click_on "Create New"
    fill_in "title", with: "Test Todo"
    fill_in "body", with: "Test Todo Body"
    click_on "Create"
    click_on "Mannage", match: :first
    check "done"
    click_on "Update"
    expect(page).to have_content "Done"
  end
end
