require 'test_helper'

class MonthlyReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get monthly_reports_index_url
    assert_response :success
  end

  test "should get upload_report" do
    get monthly_reports_upload_report_url
    assert_response :success
  end

end
