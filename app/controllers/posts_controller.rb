class PostsController < ApplicationController
  def index
    @groups = Group.all
    @group_ids = GroupUser.select(:group_id).where(user_id: current_user.id) if user_signed_in?
    @user_groups = Group.where(id: @group_ids)
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

  def update
  end

  def edit
  end

  def destroy
  end

  private

  def post_params
    params.require(:post).permit(:title, :text, :action, {images: []}).merge(user_id: current_user.id)
  end
end
