require 'rails_helper'

RSpec.describe GroupUser, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @group = FactoryBot.create(:group, owner_id: @user.id)
    @group_user = FactoryBot.build(:group_user, user_id: @user.id, group_id: @group.id)
  end

  context '登録できる場合' do
    it 'user_idとgroup_idがあれば登録できる' do
      expect(@group_user).to be_valid
    end
  end
  context '登録できない場合' do
    it 'user_idがなければ登録できない' do
      @group_user.user_id = nil
      @group_user.valid?
      expect(@group_user.errors.full_messages).to include("User must exist", "User can't be blank")
    end
  end
  context '登録できない場合' do
    it 'group_idがなければ登録できない' do
      @group_user.group_id = nil
      @group_user.valid?
      expect(@group_user.errors.full_messages).to include("Group must exist", "Group can't be blank")
    end
  end
end
