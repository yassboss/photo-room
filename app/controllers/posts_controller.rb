class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_current_user_group, only: [:index, :show]

  def index
    @groups = Group.all
    @posts = Post.where(action: 'single').includes(:user).order('created_at DESC')
    @group_posts = GroupPost.includes(:group).order('created_at DESC')
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @comments = @post.comments.includes(:user)
    @comment = Comment.new
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  private
  def post_params
    params.require(:post).permit(
      :title, :text, :group_post_id, :action, { images: [] }).merge(user_id: current_user.id)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def set_current_user_group
    @user_groups = Group.where(id: current_user.group_users.select(:group_id)) if user_signed_in?
  end
end
