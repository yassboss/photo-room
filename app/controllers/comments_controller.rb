class CommentsController < ApplicationController
  before_action :move_to_root_path, only: [:destroy]

  def create
    if params[:post_id]
      @commentable = Post.find(params[:post_id])
    elsif params[:group_post_id]
      @commentable = GroupPost.find(params[:group_post_id])
    end

    @comment = @commentable.comments.build(comment_params)
    @comment_reply = @commentable.comments.build(comment_params)
    if params[:parent_id]
      @comment_reply.save
      redirect_back(fallback_location: root_path)
    else
      @comment.save
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    if params[:post_id]
      comment = Comment.find(params[:post_id])
    elsif params[:group_post_id]
      comment = Comment.find(params[:group_post_id])
    end
    comment.destroy
    redirect_back(fallback_location: root_path)
  end

  private
  def comment_params
    params.require(:comment).permit(:text, :parent_id).merge(user_id: current_user.id)
  end

  def move_to_root_path
    if params[:post_id]
      comment = Comment.find(params[:post_id])
      post = Post.find(params[:id])
      unless post.user_id == current_user.id || comment.user_id == current_user.id
        redirect_to root_path
      end
    elsif params[:group_post_id]
      comment = Comment.find(params[:group_post_id])
      group_post = GroupPost.find(params[:id])
      group_post_user = User.where(id: group_post.posts.select(:user_id))
      unless comment.user_id == current_user.id || group_post_user.include?(current_user)
        redirect_to root_path
      end
    end
  end
end 