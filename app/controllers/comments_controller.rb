class CommentsController < ApplicationController
  def create
    if params[:post_id] != nil
      @commentable = Post.find(params[:post_id])
    elsif params[:group_post_id] != nil
      @commentable = GroupPost.find(params[:group_post_id])
    end

    @comment = @commentable.comments.build(comment_params)
    @comment.save
    redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id)
  end
end