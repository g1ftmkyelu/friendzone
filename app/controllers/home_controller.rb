class HomeController < ApplicationController
  before_action :require_login, only: [:index]

  def index
    @posts = Post.includes(:user, :likes, :comments).order(created_at: :desc)
    @post = Post.new # For the create post form on the home page
  end
end