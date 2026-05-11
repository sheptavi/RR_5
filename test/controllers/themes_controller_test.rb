require "test_helper"

class ThemesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get themes_index_url
    assert_response :success
  end

  test "should get show" do
    get themes_show_url
    assert_response :success
  end

  test "should get new" do
    get themes_new_url
    assert_response :success
  end

  test "should get edit" do
    get themes_edit_url
    assert_response :success
  end

  test "should get create" do
    get themes_create_url
    assert_response :success
  end

  test "should get update" do
    get themes_update_url
    assert_response :success
  end

  test "should get destroy" do
    get themes_destroy_url
    assert_response :success
  end
end
