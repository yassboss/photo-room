class GroupsController < ApplicationController
  before_action :set_group_set_member, only: [:show, :edit, :update]
  before_action :ensure_owner, only: [:edit, :update]

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
    # header.html.erb
    @user_groups = Group.where(id: current_user.group_users.select(:group_id)) if user_signed_in?
    # show.html.erb
    @groups = Group.includes(:user)
    @owner = User.find(@group.owner_id)
  end

  def edit
  end

  def update
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

  def set_group_set_member
    @group = Group.find(params[:id])
    @member = User.where(id: @group.group_users.select(:user_id))
  end

  def ensure_owner
    redirect_to group_path(@group) unless @group.owner_id == current_user.id
  end
end
