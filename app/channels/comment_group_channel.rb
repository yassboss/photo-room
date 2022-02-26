class CommentGroupChannel < ApplicationCable::Channel
  def subscribed
    @group_post = GroupPost.find(params[:group_post_id])
    stream_for @group_post
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
