require 'rails_helper'

RSpec.describe '新規投稿', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context '新規投稿ができるとき' do
    it 'ログインしたユーザーは写真の新規投稿ができる' do
      # ログインする
      visit new_user_session_path
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      find('input[name="commit"]').click
      # 新規出品ページへのボタンがあることを確認する
      expect(page).to have_content('New Post')
      # 出品ページに移動する
      visit new_post_path
      # フォームに情報を入力する
      attach_file 'post[images][]', 'public/images/test_image.png', make_visible: true
      fill_in 'post[title]', with: 'post_title'
      fill_in 'post[text]', with: 'text'
      # 送信するとPostモデルのカウントが1上がることを確認する
      expect  do
        find('input[name="commit"]').click
      end.to change { Post.count }.by(1)
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # トップページには先ほど投稿した写真が存在することを確認する（画像）
      expect(page).to have_selector "img[src$='test_image.png']"
      # トップページには先ほど投稿した写真が存在することを確認する（タイトル）
      expect(page).to have_content('post_title')
    end
  end
  context '新規投稿できないとき' do
    it 'ログインしていないと投稿ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # 投稿ページにリクエストするとログインページへ戻されることを確認する
      visit new_post_path
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe '投稿編集', type: :system do
  before do
    @post_01 = FactoryBot.create(:post, :assoc, group_post_id: 0)
    @post_02 = FactoryBot.create(:post, :assoc, group_post_id: 0)
  end
  context '投稿編集ができるとき' do
    it 'ログインしたユーザーは自分が投稿した写真の編集ができる' do
      # 写真01を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'user[email]', with: @post_01.user.email
      fill_in 'user[password]', with: @post_01.user.password
      find('input[name="commit"]').click
      # 写真01の詳細ページに遷移する
      visit post_path(@post_01)
      # 写真01に「編集」へのリンクがあることを確認する
      expect(page).to have_content('編集')
      # 編集ページへ遷移する
      visit edit_post_path(@post_01)
      # すでに投稿済みの内容がフォームに入っていることを確認する
      expect(page).to have_content(@post_01.title)
      # 投稿内容を編集する
      fill_in 'post[title]', with: '編集した'
      # 編集してもPostモデルのカウントは変わらないことを確認する
      expect  do
        find('input[name="commit"]').click
      end.to change { Post.count }.by(0)
      # 投稿詳細ページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # 投稿詳細ページには先ほど変更した内容の写真が存在することを確認する
      expect(page).to have_content('編集した')
    end
  end
  context '投稿編集ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿した写真の編集画面には遷移できない' do
      # 写真01を出品したユーザーでログインする
      visit new_user_session_path
      fill_in 'user[email]', with: @post_01.user.email
      fill_in 'user[password]', with: @post_01.user.password
      find('input[name="commit"]').click
      # 写真02に「編集」へのリンクがないことを確認する
      visit post_path(@post_02)
      expect(page).to have_no_content('編集')
    end
    it 'ログインしていないと投稿の編集画面には遷移できない' do
      # 写真01の投稿詳細ページにいく
      visit post_path(@post_01)
      # 写真01に「編集」へのリンクがないことを確認する
      expect(page).to have_no_content('編集')
      # 写真02の投稿詳細ページにいく
      visit post_path(@post_02)
      # 写真02に「編集」へのリンクがないことを確認する
      expect(page).to have_no_content('編集')
    end
  end
end

RSpec.describe '投稿削除', type: :system do
  before do
    @post_01 = FactoryBot.create(:post, :assoc, group_post_id: 0)
    @post_02 = FactoryBot.create(:post, :assoc, group_post_id: 0)
  end
  context '投稿削除ができるとき' do
    it 'ログインしたユーザーは自らが投稿した写真の削除ができる' do
      # 写真01を出品したユーザーでログインする
      visit new_user_session_path
      fill_in 'user[email]', with: @post_01.user.email
      fill_in 'user[password]', with: @post_01.user.password
      find('input[name="commit"]').click
      # 写真01に「削除」へのリンクがあることを確認する
      visit post_path(@post_01)
      expect(page).to have_content('削除')
      # 写真を削除するとレコードの数が1減ることを確認する
      expect do
        find_link('削除', href: post_path(@post_01)).click
      end.to change { Post.count }.by(-1)
      # トップページに遷移したことを確認する
      expect(current_path).to eq(root_path)
      # トップページには写真01の内容が存在しないことを確認する（画像）
      expect(page).to have_no_content('test_image.png')
      # トップページには写真01の内容が存在しないことを確認する
      expect(page).to have_no_content(@post_01.title)
    end
  end
  context '投稿削除ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿した写真の削除ができない' do
      # 写真01を出品したユーザーでログインする
      visit new_user_session_path
      fill_in 'user[email]', with: @post_01.user.email
      fill_in 'user[password]', with: @post_01.user.password
      find('input[name="commit"]').click
      # 写真02に「削除」へのリンクがないことを確認する
      visit post_path(@post_02)
      expect(page).to have_no_content('削除')
    end
    it 'ログインしていないと商品の削除ボタンがない' do
      # 写真01に「削除」へのリンクがないことを確認する
      visit post_path(@post_01)
      expect(page).to have_no_content('削除')
      # 写真02に「削除」へのリンクがないことを確認する
      visit post_path(@post_02)
      expect(page).to have_no_content('削除')
    end
  end
end