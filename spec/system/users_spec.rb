require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
    sleep 0.2
  end
  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page.body).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'user_nickname', with: @user.nickname
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      fill_in 'user_password_confirmation', with: @user.password_confirmation
      attach_file 'user_image', 'public/uploads/test_image.png', make_visible: true
      fill_in 'user_last_name', with: @user.last_name
      fill_in 'user_first_name', with: @user.first_name
      fill_in 'user_main_camera', with: @user.main_camera
      select '北海道', from: 'user_prefecture_id'
      select '1年未満', from: 'user_camera_experience_id'
      # サインアップボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { User.count }.by(1)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # ログアウトボタンが表示されることを確認する
      expect(page.body).to have_content('ログアウト')
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page.body).to have_no_content('新規登録')
      expect(page.body).to have_no_content('ログイン')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page.body).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'user_nickname', with: ''
      fill_in 'user_email', with: ''
      fill_in 'user_password', with: ''
      fill_in 'user_password_confirmation', with: ''
      attach_file 'user_image', 'public/uploads/test_image.png', make_visible: true
      fill_in 'user_last_name', with: ''
      fill_in 'user_first_name', with: ''
      fill_in 'user_main_camera', with: ''
      select '---', from: 'user_prefecture_id'
      select '---', from: 'user_camera_experience_id'
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq user_registration_path
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ログインができるとき' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page.body).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq(root_path)
      # ログアウトボタンが表示されることを確認する
      expect(page.body).to have_content('ログアウト')
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page.body).to have_no_content('新規登録')
      expect(page.body).to have_no_content('ログイン')
    end
  end
  context 'ログインができないとき' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page.body).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'user_email', with: ''
      fill_in 'user_password', with: ''
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻されることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe 'ユーザー情報編集', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ユーザー情報が編集できるとき' do
    it '正しい情報を入力すればユーザー編集ができてトップページに移動する' do
      # ログインする
      visit new_user_session_path
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq(root_path)
      # ユーザーニックネームが表示されることを確認する
      expect(page.body).to have_content(@user.nickname)
      # ユーザーニックネームをクリックするとユーザー情報編集ページに遷移する
      find_link(@user.nickname.to_s).click
      # ユーザー情報を入力する
      fill_in 'user_nickname', with: 'change-name'
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      fill_in 'user_password_confirmation', with: @user.password_confirmation
      fill_in 'user_current_password', with: @user.password
      attach_file 'user_image', 'public/uploads/test_image.png', make_visible: true
      fill_in 'user_main_camera', with: @user.main_camera
      select '北海道', from: 'user_prefecture_id'
      select '1年未満', from: 'user_camera_experience_id'
      # アップデートボタンを押してもユーザーモデルのカウントが上がらないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { User.count }.by(0)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # ログアウトボタンが表示されることを確認する
      expect(page.body).to have_content('ログアウト')
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page.body).to have_no_content('新規登録')
      expect(page.body).to have_no_content('ログイン')
    end
  end
  context 'ユーザー情報が編集できないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # ログインする
      visit new_user_session_path
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq(root_path)
      # ユーザーニックネームが表示されることを確認する
      expect(page.body).to have_content(@user.nickname)
      # ユーザーニックネームをクリックするとユーザー情報編集ページに遷移する
      find_link(@user.nickname.to_s).click
      # ユーザー情報を入力する
      fill_in 'user_nickname', with: ''
      fill_in 'user_email', with: ''
      fill_in 'user_password', with: ''
      fill_in 'user_password_confirmation', with: ''
      fill_in 'user_current_password', with: ''
      attach_file 'user_image', 'public/uploads/test_image.png', make_visible: true
      fill_in 'user_main_camera', with: ''
      select '---', from: 'user_prefecture_id'
      select '---', from: 'user_camera_experience_id'
      # アップデートボタンを押す
      find('input[name="commit"]').click
      # ユーザー情報編集ページへ戻されることを確認する
      expect(current_path).to eq user_registration_path
    end
  end
end
