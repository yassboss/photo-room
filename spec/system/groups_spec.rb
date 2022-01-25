require 'rails_helper'

RSpec.describe '新規グループ登録', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
    @group = FactoryBot.build(:group)
  end
  context '新規グループ登録ができるとき' do
    it '正しい情報を入力すれば新規グループ登録ができてトップページに移動する' do
      # ログインする
      visit new_user_session_path
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      find('input[name="commit"]').click
      # グループ新規登録ボタンがあることを確認する
      expect(page).to have_content('New Group')
      # グループ新規登録ページに遷移する
      visit new_group_path
      # グループ情報を入力する
      fill_in 'group_name', with: @group.name
      fill_in 'group_introduction', with: @group.introduction
      select @another_user.nickname.to_s, from: 'group[user_ids][]', match: :first
      # 登録ボタンを押すとgroupモデルのカウントが1上がること、group_usersモデルのカウントが2上がることを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Group.count }.by(1).and change { GroupUser.count }.by(2)
      # グループ紹介文やグループ編集ボタンが表示されることを確認する
      expect(page.body).to have_content(@group.introduction)
      expect(page.body).to have_content("#{@group.name}の編集")
    end
  end
  context '新規グループ登録ができないとき' do
    it '誤った情報では新規グループ登録ができずに新規登録ページへ戻ってくる' do
      # ログインする
      visit new_user_session_path
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      find('input[name="commit"]').click
      # グループ新規登録ページに遷移する
      visit new_group_path
      # グループ情報を入力する
      fill_in 'group_name', with: ''
      fill_in 'group_introduction', with: ''
      select @another_user.nickname.to_s, from: 'group[user_ids][]', match: :first
      # 登録ボタンを押してもgroupモデルのカウント、group_usersモデルのカウントが上がらないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Group.count }.by(0).and change { GroupUser.count }.by(0)
      # /groupsへ戻されることを確認する
      expect(current_path).to eq '/groups'
    end
  end
end
RSpec.describe 'グループ情報編集', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @group = FactoryBot.create(:group, owner_id: @user.id)
    @group_user = GroupUser.create(group_id: @group.id, user_id: @user.id)
  end
  context 'グループ情報が編集できるとき' do
    it '正しい情報を入力すればグループ編集ができてグループ詳細ページに移動する' do
      # ログインする
      visit new_user_session_path
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq(root_path)
      # グループ詳細ページへのリンクが存在することを確認する
      expect(
        find('.select-group').click
      ).to have_content @group.name.to_s
      # グループ詳細ページへ遷移する
      visit group_path(@group)
      # グループ編集ボタンが表示されることを確認する
      expect(page.body).to have_content("#{@group.name}の編集")
      # グループ編集ページへ遷移する
      visit edit_group_path(@group)
      # グループ情報を入力する
      fill_in 'group_name', with: @group.name
      fill_in 'group_introduction', with: 'edit'
      # アップデートボタンを押してもユーザーモデルのカウントが上がらないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Group.count }.by(0).and change { GroupUser.count }.by(0)
      # グループ詳細ページへ遷移したことを確認する
      expect(current_path).to eq(group_path(@group))
      # グループ紹介文やグループ編集ボタンが表示されることを確認する
      expect(page.body).to have_content('edit')
      expect(page.body).to have_content("#{@group.name}の編集")
    end
  end
  context 'グループ情報が編集できないとき' do
    it '誤った情報ではグループ登録ができずに新規登録ページへ戻ってくる' do
      # ログインする
      visit new_user_session_path
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      find('input[name="commit"]').click
      # グループ詳細ページへ遷移する
      visit group_path(@group)
      # グループ編集ボタンが表示されることを確認する
      expect(page.body).to have_content("#{@group.name}の編集")
      # グループ編集ページへ遷移する
      visit edit_group_path(@group)
      # グループ情報を入力する
      fill_in 'group_name', with: ''
      fill_in 'group_introduction', with: ''
      # 登録ボタンを押す
      find('input[name="commit"]').click
      # グループページへ戻されることを確認する
      expect(current_path).to eq(group_path(@group))
    end
  end
end
