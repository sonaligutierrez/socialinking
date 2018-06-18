require "test_helper"


class PostControllerTest < ActionDispatch::IntegrationTest
  test "index system" do
    get admin_posts_url
    assert_template partial: %r{\Aadmin/_index_posts\Z}, locals: { posts: @posts }
    assert_response :redirect
  end
end


    
   