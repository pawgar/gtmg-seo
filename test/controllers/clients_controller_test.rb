require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  test "should get add_notes" do
    get :add_notes
    assert_response :success
  end

  test "should get update_notes" do
    get :update_notes
    assert_response :success
  end

end
