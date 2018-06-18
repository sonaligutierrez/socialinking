require "test_helper"

class PostControllerTest < ActionDispatch::IntegrationTest
  test "index system" do
    get admin_posts_url
    assert_template :index
    assert_equal Post.all, assigns(:posts)
    assert_response :success
  end
end
