class BlogsController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @blogs = Blog.includes(:user).order(created_at: :desc)
  end

  def show
  end

  def new
    @blog = current_user.blogs.build
  end

  def create
    @blog = current_user.blogs.build(blog_params)
    if @blog.save
      redirect_to @blog, notice: 'Blog post was successfully created.'
    else
      flash.now[:alert] = 'Blog post could not be created.'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @blog.update(blog_params)
      redirect_to @blog, notice: 'Blog post was successfully updated.'
    else
      flash.now[:alert] = 'Blog post could not be updated.'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blog.destroy
    redirect_to blogs_path, notice: 'Blog post was successfully deleted.'
  end

  private

  def set_blog
    @blog = Blog.find(params[:id])
  end

  def blog_params
    params.require(:blog).permit(:title, :content)
  end
end