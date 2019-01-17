require "test_helper"


class PostControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "publication info" do
    sign_in users(:one)
    post = Post.first
    post.post_reactions << post_reactions(:one)
    post.post_shared << post_shared(:one)
    post.save
    get admin_post_url(post)
    assert_response :success
    assert_match "Prueba", @response.body
    assert_match "Comentario de prueba", @response.body
    assert_match "Editar Publicación", @response.body
    assert_match "Comentarios", @response.body

    assert_match "Reacciones", @response.body
    assert_match "Norberto Sampol", @response.body

    assert_match "Compartidos", @response.body
    assert_match "Juan Daniel González", @response.body
  end

  test "comments" do
    sign_in users(:one)
    post = Post.first
    get admin_post_comments_url
    assert_response :success
    assert_match "Categorizar", @response.body
    assert_match "Comentario de prueba", @response.body
    assert_match "Filtrar comentarios", @response.body
    assert_match "Añadir comentarios", @response.body

    assert_match "Norberto Sampol", @response.body

  end
end
