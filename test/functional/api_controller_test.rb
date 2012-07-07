require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get rentals_json" do
    get :rentals_json
    assert_response :success
  end

end
