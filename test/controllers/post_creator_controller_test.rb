require "test_helper"


class PostCreatorControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "index" do
    sign_in users(:one)
    get admin_post_creators_url
    assert_response :success
    assert_match "Publicadores", @response.body
    assert_match "Cambiemos", @response.body
  end
end
