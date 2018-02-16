require 'test_helper'

class OffpageCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get offpage_categories_index_url
    assert_response :success
  end

end
