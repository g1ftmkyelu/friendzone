class UsersController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authorize_user!, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id # Log in the user immediately
      redirect_to root_path, notice: 'Account created successfully!'
    else
      flash.now[:alert] = 'Account creation failed.'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @posts = @user.posts.order(created_at: :desc)
    @friendship_status = current_user.friendship_status_with(@user) if logged_in? && current_user != @user
  end

  def edit
    # Render settings form
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile updated successfully!'
    else
      flash.now[:alert] = 'Profile update failed.'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :username, :bio, :avatar, :password, :password_confirmation)
  end

  def authorize_user!
    unless @user == current_user
      flash[:alert] = 'You are not authorized to edit this profile.'
      redirect_to root_path
    end
  end
end