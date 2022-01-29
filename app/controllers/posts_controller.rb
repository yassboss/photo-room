class PostsController < ApplicationController
  def index
    @groups = Group.all
    @group_ids = GroupUser.select(:group_id).where(user_id: current_user.id) if user_signed_in?
    @user_groups = Group.where(id: @group_ids)

    @posts = Post.includes(:user).order('created_at DESC')
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
    @post = Post.find(params[:id])

    @group_ids = GroupUser.select(:group_id).where(user_id: current_user.id) if user_signed_in?
    @user_groups = Group.where(id: @group_ids)
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :text, :action, {images: []}).merge(user_id: current_user.id)
  end
end
