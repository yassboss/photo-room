require 'rails_helper'

RSpec.describe Group, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @group = FactoryBot.build(:group)
    @group.owner_id = @user.id
    sleep 0.5
  end

  describe 'グループ新規登録' do
    context '新規登録できる場合' do
      it '必要項目が全て存在すれば登録できる' do
        expect(@group).to be_valid
      end
    end
    context '新規登録できない場合' do
      it 'nameが空では登録できない' do
        @group.name = ''
        @group.valid?
        expect(@group.errors.full_messages).to include("Name can't be blank")
      end
      it 'introductionが空では登録できない' do
        @group.introduction = ''
        @group.valid?
        expect(@group.errors.full_messages).to include("Introduction can't be blank")
      end
      it 'owner_idが空では登録できない' do
        @group.owner_id = ''
        @group.valid?
        expect(@group.errors.full_messages).to include("Owner can't be blank")
      end
    end
  end
end
