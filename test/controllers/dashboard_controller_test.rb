require "test_helper"


class DashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "dashboard" do
    sign_in users(:one)
    get admin_dashboard_url
    assert_response :success
    assert_match "Cantidad de Comentarios por Categoría", @response.body
    assert_match "Categorizados vs No Categorizados", @response.body
    assert_match "Últimas 10 Publicaciones", @response.body
  end
end
