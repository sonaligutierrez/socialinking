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

  test "show" do
    @post = posts(:three)
    sign_in users(:one)
    get admin_post_url(@post)
    assert_template partial: %r{\Aadmin/posts/_show_post\Z}, locals: { post: @post }
    assert_match "Publicaciones", @response.body
    assert_match "Cambiemos", @response.body
    assert_match "Comentario de prueba", @response.body

  end
end
