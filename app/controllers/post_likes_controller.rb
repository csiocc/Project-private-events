class PostLikesController < ApplicationController
  before_action :set_post

  def create
    @post.post_likes.find_or_create_by(user: current_user)
    respond_to do |format|
      format.html { redirect_to @post, notice: "Post geliked!" }
      format.turbo_stream { render 'posts/like' }
    end
  end

  def destroy
    @post.post_likes.where(user: current_user).destroy_all
    respond_to do |format|
      format.html { redirect_to @post, notice: "Like entfernt!" }
      format.turbo_stream { render 'posts/like' }
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end
end