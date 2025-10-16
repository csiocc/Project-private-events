require "application_system_test_case"

class DailyLogsTest < ApplicationSystemTestCase
  setup do
    @daily_log = daily_logs(:one)
  end

  test "visiting the index" do
    visit daily_logs_url
    assert_selector "h1", text: "Daily logs"
  end

  test "should create daily log" do
    visit daily_logs_url
    click_on "New daily log"

    click_on "Create Daily log"

    assert_text "Daily log was successfully created"
    click_on "Back"
  end

  test "should update Daily log" do
    visit daily_log_url(@daily_log)
    click_on "Edit this daily log", match: :first

    click_on "Update Daily log"

    assert_text "Daily log was successfully updated"
    click_on "Back"
  end

  test "should destroy Daily log" do
    visit daily_log_url(@daily_log)
    accept_confirm { click_on "Destroy this daily log", match: :first }

    assert_text "Daily log was successfully destroyed"
  end
end
