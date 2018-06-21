require "test_helper"


class PostControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "comments" do
    sign_in users(:one)
    get comments_admin_post_url(Post.first)
    assert_response :success
    assert_match "Prueba", @response.body
    assert_match "Comentario de prueba", @response.body
  end
end
