class LikesController < ApplicationController
  before_action :require_login
  before_action :set_post

  def create
    @like = @post.likes.build(user: current_user)
    if @like.save
      redirect_to @post, notice: 'Post liked!'
    else
      redirect_to @post, alert: 'Unable to like post.'
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)
    if @like
      @like.destroy
      redirect_to @post, notice: 'Post unliked.'
    else
      redirect_to @post, alert: 'You have not liked this post.'
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end