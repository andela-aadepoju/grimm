require_relative "feature_helper"

describe "create todo lists", type: :feature do
  let(:last_list) { List.last[0] }

  it "marks a post as done" do
    visit "/"
    click_on "Create New"
    fill_in "title", with: "Test Todo"
    fill_in "body", with: "Test Todo Body"
    click_on "Create"
    expect(page).to have_content "Undone"
    visit "/lists/edit/#{last_list}"
    check "done"
    page.driver.put "/lists/edit/#{last_list}"
    expect(page).to have_content "Done"
  end
end
