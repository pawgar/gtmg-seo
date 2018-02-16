require 'test_helper'

class StrategyOffpageCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get strategy_offpage_categories_new_url
    assert_response :success
  end

  test "should get create" do
    get strategy_offpage_categories_create_url
    assert_response :success
  end

end
