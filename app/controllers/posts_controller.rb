class PostsController < ApplicationController
  def index
    @groups = Group.all
    @group_ids = GroupUser.select(:group_id).where(user_id: current_user.id) if user_signed_in?
    @user_groups = Group.where(id: @group_ids)
  end
end
