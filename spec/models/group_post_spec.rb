require 'rails_helper'

RSpec.describe GroupPost, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @group = FactoryBot.create(:group, owner_id: @user.id)
    @group_post = FactoryBot.build(:group_post, group_id: @group.id )
    @post = FactoryBot.build(:post, group_post_id: @group_post.id, user_id: @user.id)
    sleep 0.5
  end

  describe '写真の新規投稿' do
    context '新規投稿できる場合' do
      it '必要項目が全て存在すれば登録できる' do
        expect(@group_post).to be_valid
      end
    end
    context '新規投稿できない場合' do
      it 'titleが空では登録できない' do
        @group_post.group_title = ''
        @group_post.valid?
        expect(@group_post.errors.full_messages).to include("Group title can't be blank")
      end
      it 'textが空では登録できない' do
        @group_post.group_text = ''
        @group_post.valid?
        expect(@group_post.errors.full_messages).to include("Group text can't be blank")
      end
      it 'groupが紐付いていないと保存できない' do
        @group_post.group = nil
        @group_post.valid?
        expect(@group_post.errors.full_messages).to include("Group must exist")
      end
    end
  end
end
