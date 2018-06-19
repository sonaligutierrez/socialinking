require "test_helper"


class PostControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "index" do
    sign_in users(:one)
    get admin_posts_url
    assert_template partial: %r{\Aadmin/posts/_index_posts\Z}, locals: { posts: @posts }
    assert_match "Publicaciones", @response.body
    assert_match "Cambiemos", @response.body
  end
end
