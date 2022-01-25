class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :set_member_in_out, only: [:edit, :update]

  def new
    @group = Group.new
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
    @groups = Group.includes(:user)
    @group = Group.find(params[:id])
    @user_groups = Group.where(id: GroupUser.select(:group_id).where(user_id: current_user.id)) if user_signed_in?

    @members = User.where(id: GroupUser.select(:user_id).where(group_id: @group.id))
    @owner = User.find(@group.owner_id)
  end

  def edit
  end

  def update
    @group.owner_id = current_user.id
    if @group.update(group_params)
      redirect_to group_path(@group)
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
    redirect_to group_path(@group) unless @group.owner_id == current_user.id
  end

  def set_member_in_out
    @members = User.where(id: GroupUser.select(:user_id).where(group_id: @group.id))
    @add_members = User.where.not(id: current_user.id && @members.ids)
  end
end
