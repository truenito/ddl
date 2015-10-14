class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :redirect_to_mobile_if_applicable

  def redirect_to_mobile_if_applicable
    redirect_to mobile_path if mobile_device?
  end

  def mobile_device?
   request.user_agent =~ /Mobile|webOS/
  end

  # rescue_from CanCan::AccessDenied do |exception|
  #   redirect_to main_app.root_path, :alert => exception.message
  # end
end
