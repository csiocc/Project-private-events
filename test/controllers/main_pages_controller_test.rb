require "test_helper"

class MainPagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @main_page = main_pages(:one)
  end

  test "should get index" do
    get main_pages_url
    assert_response :success
  end

  test "should get new" do
    get new_main_page_url
    assert_response :success
  end

  test "should create main_page" do
    assert_difference("MainPage.count") do
      post main_pages_url, params: { main_page: {} }
    end

    assert_redirected_to main_page_url(MainPage.last)
  end

  test "should show main_page" do
    get main_page_url(@main_page)
    assert_response :success
  end

  test "should get edit" do
    get edit_main_page_url(@main_page)
    assert_response :success
  end

  test "should update main_page" do
    patch main_page_url(@main_page), params: { main_page: {} }
    assert_redirected_to main_page_url(@main_page)
  end

  test "should destroy main_page" do
    assert_difference("MainPage.count", -1) do
      delete main_page_url(@main_page)
    end

    assert_redirected_to main_pages_url
  end
end
