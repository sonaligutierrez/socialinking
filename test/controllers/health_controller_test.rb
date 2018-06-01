require "test_helper"

class HealthControllerTest < ActionDispatch::IntegrationTest
  test "healty system" do
    get("/")
    assert_equal(302, status)
  end
end
