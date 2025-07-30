class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @post, notice: 'Comment was successfully created.'
    else
      flash[:alert] = 'Comment could not be created.'
      redirect_to @post
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_to @post, notice: 'Comment was successfully deleted.'
    else
      flash[:alert] = 'You are not authorized to delete this comment.'
      redirect_to @post
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end