class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_user

  def set_current_user
    Current.user = User.find_by(id: session[:user_id])
  end

  def authenticate_user!
    redirect_to login_path, alert: "You must be logged in to do that." if Current.user.nil?
  end

  def logged_in?
    Current.user.present?
  end
  helper_method :logged_in?
end
