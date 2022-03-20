require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @post = FactoryBot.create(:post, group_post_id: 0, user_id: @user.id)
    @comment = FactoryBot.build(:comment, commentable_id: @post.id, commentable_type: 'Post')
    sleep 0.5
  end

  describe 'コメントの新規投稿' do
    context '新規コメントできる場合' do
      it '必要項目が全て存在すればコメントできる' do
        expect(@comment).to be_valid
      end
    end
    context '新規コメントできない場合' do
      it 'textが空では登録できない' do
        @comment.text = ''
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Text can't be blank")
      end
      it 'userが紐付いていないと保存できない' do
        @comment.user = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include("User must exist")
      end
    end
  end
end
