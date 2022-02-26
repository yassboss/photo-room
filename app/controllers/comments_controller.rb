class CommentsController < ApplicationController
  before_action :move_to_root_path, only: [:destroy]

  def create
    @commentable = Post.find(params[:post_id]) if params[:post_id]
    @commentable = GroupPost.find(params[:group_post_id]) if params[:group_post_id]

    @comment = @commentable.comments.build(comment_params)
    @comment_reply = @commentable.comments.build(comment_params)

    @post = Post.find(params[:post_id]) if params[:post_id]
    @group_post = GroupPost.find(params[:group_post_id]) if params[:group_post_id]

    if params[:parent_id]
      @comment_reply.save
      if @comment_reply.save && @group_post
        CommentGroupChannel.broadcast_to @group_post,
                                         { comment: @comment_reply,
                                           user: @comment_reply.user }
      end
      CommentChannel.broadcast_to @post, { comment: @comment_reply, user: @comment_reply.user } if @comment_reply.save && @post
    else
      @comment.save
      CommentGroupChannel.broadcast_to @group_post, { comment: @comment, user: @comment.user } if @comment.save && @group_post
      CommentChannel.broadcast_to @post, { comment: @comment, user: @comment.user } if @comment.save && @post
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
      redirect_to root_path unless post.user_id == current_user.id || comment.user_id == current_user.id
    elsif params[:group_post_id]
      comment = Comment.find(params[:group_post_id])
      group_post = GroupPost.find(params[:id])
      group_post_user = User.where(id: group_post.posts.select(:user_id))
      redirect_to root_path unless comment.user_id == current_user.id || group_post_user.include?(current_user)
    end
  end
end
