require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @post = FactoryBot.build(:post, group_post_id: 0, user_id: @user.id)
  end

  describe '写真の新規投稿' do
    context '新規投稿できる場合' do
      it '必要項目が全て存在すれば登録できる' do
        expect(@post).to be_valid
      end
    end
    context '新規投稿できない場合' do
      it '画像が空では登録できない' do
        @post.images = nil
        @post.valid?
        expect(@post.errors.full_messages).to include("Images can't be blank", "Images は1枚以上5枚以下にしてください")
      end
      it 'titleが空では登録できない' do
        @post.title = ''
        @post.valid?
        expect(@post.errors.full_messages).to include("Title can't be blank")
      end
      it 'textが空では登録できない' do
        @post.text = ''
        @post.valid?
        expect(@post.errors.full_messages).to include("Text can't be blank")
      end
      it 'group_post_idが空では登録できない' do
        @post.group_post_id = ''
        @post.valid?
        expect(@post.errors.full_messages).to include("Group post can't be blank")
      end
      it 'userが紐付いていないと保存できない' do
        @post.user = nil
        @post.valid?
        expect(@post.errors.full_messages).to include("User can't be blank")
      end
    end
  end
end
