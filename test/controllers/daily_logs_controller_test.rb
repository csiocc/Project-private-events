require "test_helper"

class DailyLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @daily_log = daily_logs(:one)
  end

  test "should get index" do
    get daily_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_daily_log_url
    assert_response :success
  end

  test "should create daily_log" do
    assert_difference("DailyLog.count") do
      post daily_logs_url, params: { daily_log: {} }
    end

    assert_redirected_to daily_log_url(DailyLog.last)
  end

  test "should show daily_log" do
    get daily_log_url(@daily_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_daily_log_url(@daily_log)
    assert_response :success
  end

  test "should update daily_log" do
    patch daily_log_url(@daily_log), params: { daily_log: {} }
    assert_redirected_to daily_log_url(@daily_log)
  end

  test "should destroy daily_log" do
    assert_difference("DailyLog.count", -1) do
      delete daily_log_url(@daily_log)
    end

    assert_redirected_to daily_logs_url
  end
end
