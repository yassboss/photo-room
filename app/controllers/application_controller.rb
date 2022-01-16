class ApplicationController < ActionController::Base
  before_action :basic_auth
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, except: :index

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:nickname, :image, :last_name, :first_name, :main_camera, :prefecture_id, :camera_experience_id])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: [:nickname, :image, :main_camera, :prefecture_id, :camera_experience_id])
  end
end
