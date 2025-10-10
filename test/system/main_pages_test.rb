require "application_system_test_case"

class MainPagesTest < ApplicationSystemTestCase
  setup do
    @main_page = main_pages(:one)
  end

  test "visiting the index" do
    visit main_pages_url
    assert_selector "h1", text: "Main pages"
  end

  test "should create main page" do
    visit main_pages_url
    click_on "New main page"

    click_on "Create Main page"

    assert_text "Main page was successfully created"
    click_on "Back"
  end

  test "should update Main page" do
    visit main_page_url(@main_page)
    click_on "Edit this main page", match: :first

    click_on "Update Main page"

    assert_text "Main page was successfully updated"
    click_on "Back"
  end

  test "should destroy Main page" do
    visit main_page_url(@main_page)
    click_on "Destroy this main page", match: :first

    assert_text "Main page was successfully destroyed"
  end
end
