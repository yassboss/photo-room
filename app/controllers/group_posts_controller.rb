class GroupPostsController < ApplicationController
  before_action :set_group_post, only: [:show, :edit, :update, :destroy]
  before_action :set_group_and_group_users, only: [:edit, :update]

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
    # header.html.erb
    @user_groups = Group.where(id: current_user.group_users.select(:group_id)) if user_signed_in?
    # show.html.erb
    @group_post_users = User.where(id: Post.select(:user_id).where(id: @group_post.posts.ids))
    @comments = @group_post.comments.includes(:user).order('created_at DESC')
  end

  def edit
  end

  def update
    if @group_post.update(group_post_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @group_post.destroy
    redirect_to root_path
  end

  private

  def group_post_params
    params.require(:group_post).permit(:group_title, :group_text, :group_id,
                                       posts_attributes: [:id, :title, :text, :action, :group_post_id, :user_id, :_destroy, { images: [] }])
  end

  def set_group_post
    @group_post = GroupPost.find(params[:id])
  end

  def set_group_and_group_users
    @group = Group.find(@group_post.group_id)
    @group_users = User.where(id: @group.group_users.ids)
  end
end
