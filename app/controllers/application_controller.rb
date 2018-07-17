class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def unauthorized(info)
    redirect_to unauthorized_path
  end
end
