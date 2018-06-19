require "test_helper"


class PostControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "index system" do
    sign_in users(:one)
    get admin_posts_url
    assert_response :success
    assert_match "Publicaciones", @response.body
    assert_match "Cambiemos", @response.body
  end
end
