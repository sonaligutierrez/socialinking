require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test "posts#scraping" do

    get post_scraping_path(Post.last.id)
    assert_response :redirect
    assert_redirected_to admin_posts_path
    assert_equal flash[:notice], "Scraping agendado para la publicacion"

  end
end
