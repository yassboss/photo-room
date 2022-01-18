class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def new
    @group = Group.new
    @group.users << current_user
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
    @group_members = GroupUser.select(:user_id).where(group_id: @group.id)
    @members = User.where(id: @group_members)
    @owner = User.find(@group.owner_id)
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path(@group)
    else
      render :edit
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :owner_id, user_ids: [])
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end