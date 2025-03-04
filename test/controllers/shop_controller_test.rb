require "test_helper"

class ShopControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get shop_index_url
    assert_response :success
  end

  test "should get show" do
    get shop_show_url
    assert_response :success
  end

  test "should get checkout" do
    get shop_checkout_url
    assert_response :success
  end

  test "should get success" do
    get shop_success_url
    assert_response :success
  end
end
