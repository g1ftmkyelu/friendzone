class HomeController < ApplicationController
  before_action :require_login, only: [:index]

  def index
    @posts = Post.includes(:user, :likes, :comments).order(created_at: :desc)
    @post = Post.new # For the create post form on the home page

    if logged_in?
      @recommended_users = current_user.recommended_users(limit: 5)
    else
      @recommended_users = [] # No recommendations for logged out users
    end
  end
end