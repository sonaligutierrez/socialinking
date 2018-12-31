require "test_helper"


class DashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "dashboard like admin" do
    sign_in users(:one)
    get admin_dashboard_url
    assert_response :success
    assert_match "Comentarios por Categoría", @response.body
    assert_match "Categorizados/ No categorizados", @response.body
    assert_match "Últimas 10 Publicaciones", @response.body
    assert_match "Usuarios", @response.body
    assert_match "Seguimientos", @response.body
  end

  test "dashboard no admin" do
    sign_in users(:two)
    get admin_dashboard_url
    assert_response :success
    assert_no_match "Seguimientos", @response.body
  end
end
