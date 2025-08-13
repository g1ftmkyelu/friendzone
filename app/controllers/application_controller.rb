class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?

  before_action :set_hide_layout_elements_default

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this page."
      redirect_to login_path
    end
  end

  def authorize_user!(resource)
    unless resource.user == current_user
      flash[:alert] = 'You are not authorized to perform this action.'
      redirect_to root_path
    end
  end

  def set_hide_layout_elements_default
    @hide_layout_elements = false
  end
end