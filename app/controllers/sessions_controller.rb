class SessionsController < ApplicationController
  before_action :set_hide_layout_elements, only: [:new]

  def new
    # Render login form
  end

  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Logged in successfully!'
    else
      flash.now[:alert] = 'Invalid username or password.'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: 'Logged out successfully!'
  end

  private

  def set_hide_layout_elements
    @hide_layout_elements = true
  end
end