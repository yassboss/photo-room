require 'rails_helper'

RSpec.describe 'コメント投稿', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @post = FactoryBot.create(:post, :assoc, group_post_id: 0)
  end
  context 'コメントができるとき' do
    it 'ログインしたユーザーはコメントできる' do
      # ログインする
      visit new_user_session_path
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      find('input[name="commit"]').click
      # 投稿詳細ページに遷移する
      visit post_path(@post)
      # コメントボタンが表示されていることを確認する
      expect(page).to have_content('コメント')
      # コメントボタンを押す
      find('.menu-btn').click
      # フォームに情報を入力する
      fill_in 'comment[text]', with: 'test_comment!'
      # 送信する
      find('.comment-submit-btn').click
      # 入力したコメントが表示されていることを確認する
      expect(page).to have_content('test_comment!')
    end
  end
  context 'コメントができないとき' do
    it 'ログインしていないユーザーはコメントできない' do
      # 投稿詳細ページに遷移する
      visit post_path(@post)
      # コメントボタンが表示されていることを確認する
      expect(page).to have_content('コメント')
      # コメントボタンを押す
      find('.menu-btn').click
      # コメントフォームが表示されていないことを確認する
      expect(page).to have_no_content('送信')
    end
  end
end

RSpec.describe 'コメント削除', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @post = FactoryBot.create(:post, :assoc, group_post_id: 0)
    @comment = FactoryBot.create(:comment, commentable_id: @post.id, commentable_type: 'Post' )
  end
  context 'コメントが削除できるとき' do
    it '投稿ユーザーはコメントを削除できる' do
      # ログインする
      visit new_user_session_path
      fill_in 'user[email]', with: @post.user.email
      fill_in 'user[password]', with: @post.user.password
      find('input[name="commit"]').click
      # 投稿詳細ページに遷移する
      visit post_path(@comment.commentable)
      # コメントボタンを押す
      find('.menu-btn').click
      # コメント削除ボタンが表示されていることを確認する
      expect(page).to have_selector('.comment-dele')
      # 削除ボタンを押すとCommentモデルのカウントが1下がることを確認する
      expect do
        page.find('.comment-dele').click
      end.to change { Comment.count }.by(-1)
      # 削除したコメントが表示されていないことを確認する
      expect(page).to have_no_content(@comment.text)
    end
  end
  context 'コメントが削除できないとき' do
    it '投稿ユーザー以外はコメントを削除できない' do
      # ログインする
      visit new_user_session_path
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      find('input[name="commit"]').click
      # 投稿詳細ページに遷移する
      visit post_path(@comment.commentable)
      # コメントボタンを押す
      find('.menu-btn').click
      # コメント削除ボタンが表示されないことを確認する
      expect(page).to have_no_selector('.comment-dele')
    end
  end
end