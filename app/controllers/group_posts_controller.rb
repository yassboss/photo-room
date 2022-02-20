class GroupPostsController < ApplicationController
  def new
    @group = Group.find(params[:id])
    @group_users = User.where(id: GroupUser.select(:user_id).where(group_id: @group.id))

    @group_post = GroupPost.new
    @group_post.posts.build
  end

  def create
    @group = Group.find(group_post_params[:group_id])
    @group_users = User.where(id: GroupUser.select(:user_id).where(group_id: @group.id))
    @group_post = GroupPost.new(group_post_params)
    if @group_post.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @group_post = GroupPost.find(params[:id])
  end

  def edit
    @group_post = GroupPost.find(params[:id])
    @group_users = User.where(id: GroupUser.select(:user_id).where(group_id: @group_post.group.id))
  end

  def update
    @group_post = GroupPost.find(params[:id])
    @group_users = User.where(id: GroupUser.select(:user_id).where(group_id: @group_post.group.id))
    if @group_post.update(group_post_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @group_post = GroupPost.find(params[:id])
    @group_post.destroy
    redirect_to root_path
  end

  private

  def group_post_params
    params.require(:group_post).permit(:group_title, :group_text, :group_id,
                                       posts_attributes: [:id, :title, :text, :action, :group_post_id, :user_id, :_destroy, { images: [] }])
  end
end
