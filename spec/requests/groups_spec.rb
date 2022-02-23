require 'rails_helper'

RSpec.describe 'Groups', type: :request do
  before do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
    @group = FactoryBot.create(:group, owner_id: @user.id)
    @group_user = FactoryBot.create(:group_user, user_id: @user.id, group_id: @group.id)
  end

  describe 'GET #index' do
    it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
      get root_path
      expect(response.status).to eq(200)
    end
    it 'ログイン状態でindexアクションにリクエストするとレスポンスに登録済みのグループ名が存在する' do
      sign_in @user
      get root_path
      expect(response.body).to include(@group.name)
    end
    it 'ログイン状態でindexアクションにリクエストするとレスポンスにレスポンスにユーザーのnicknameが存在する' do
      sign_in @user
      get root_path
      expect(response.body).to include(@user.nickname.to_s)
    end
    it 'ログイン状態でindexアクションにリクエストするとレスポンスにlogoutボタンが存在する' do
      sign_in @user
      get root_path
      expect(response.body).to include('Logout')
    end
    it 'ログインしていない状態でindexアクションにリクエストするとレスポンスにloginボタンが存在する' do
      get root_path
      expect(response.body).to include('Login')
    end
    it 'ログインしていない状態でindexアクションにリクエストするとレスポンスに新規登録ボタンが存在する' do
      get root_path
      expect(response.body).to include('Signup')
    end
  end

  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
      get group_path(@group)
      expect(response.status).to eq(200)
    end
    it 'showアクションにリクエストするとレスポンスに登録済みのグループ名が存在する' do
      get group_path(@group)
      expect(response.body).to include(@group.name.to_s)
    end
    it 'showアクションにリクエストするとレスポンスに登録済みのグループ紹介が存在する' do
      get group_path(@group)
      expect(response.body).to include(@group.introduction.to_s)
    end
    it 'showアクションにリクエストするとレスポンスに登録済みのグループメンバーが存在する' do
      get group_path(@group)
      expect(response.body).to include(@user.nickname.to_s)
    end
    it 'グループオーナーでログインしてshowアクションにリクエストするとレスポンスにグループ編集ボタンが存在する' do
      sign_in @user
      get group_path(@group)
      expect(response.body).to include("#{@group.name}の編集")
    end
    it 'グループオーナー以外でログインしてshowアクションにリクエストするとレスポンスにグループ編集ボタンが存在しない' do
      sign_in @another_user
      get group_path(@group)
      expect(response.body).not_to include("#{@group.name}の編集")
    end
  end

  describe 'GET #new' do
    it 'ログイン状態でnewアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @user
      get new_group_path
      expect(response.status).to eq(200)
    end
    it 'ログイン状態でnewアクションにリクエストするとレスポンスにグループ情報登録フォームが存在する' do
      sign_in @user
      get new_group_path
      expect(response.body).to include('グループ紹介（必須）')
    end
    it 'ログインしていない状態でnewアクションにリクエストするとレスポンスにステータスコード302が返ってくる' do
      get new_group_path
      expect(response.status).to eq(302)
    end
    it 'ログインしていない状態でnewアクションにリクエストするとログイン画面に遷移する' do
      get new_group_path
      expect(response).to redirect_to '/users/sign_in'
    end
  end

  describe 'POST #create' do
    it 'ログイン状態でcreateアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @user
      post groups_path,
           params: { group: { name: 'test', introduction: 'test', owner_id: @user.id, user_ids: [@user.id, @another_user.id] } }
      expect(response.status).to eq(302)
    end
    it 'ログインしていない状態でcreateアクションにリクエストするとレスポンスにステータスコード302が返ってくる' do
      post groups_path
      expect(response.status).to eq(302)
    end
  end

  describe 'GET #edit' do
    it 'グループオーナーでログインしてeditアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @user
      get edit_group_path(@group)
      expect(response.status).to eq(200)
    end
    it 'グループオーナーでログインしてeditアクションにリクエストするとレスポンスにグループ情報入力フォームが存在する' do
      sign_in @user
      get edit_group_path(@group)
      expect(response.body).to include('グループ紹介（必須）')
    end
    it 'グループオーナー以外でログインしてeditアクションにリクエストするとレスポンスにステータスコード302が返ってくる' do
      sign_in @another_user
      get edit_group_path(@group)
      expect(response.status).to eq(302)
    end
    it 'グループオーナー以外でログインしてeditアクションにリクエストするとトップページに遷移する' do
      sign_in @another_user
      get edit_group_path(@group)
      expect(response).to redirect_to group_path(@group)
    end
    it 'ログインしていない状態でeditアクションにリクエストするとレスポンスにステータスコード302が返ってくる' do
      get edit_group_path(@group)
      expect(response).to redirect_to '/users/sign_in'
    end
    it 'ログインしていない状態でeditアクションにリクエストするとログイン画面に遷移する' do
      get edit_group_path(@group)
      expect(response).to redirect_to '/users/sign_in'
    end
  end

  describe 'PUT #update' do
    it 'グループオーナーでログインしてupdateアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @user
      put group_path(@group),
          params: { group: { name: 'test01', introduction: 'test', owner_id: @user.id, user_ids: [@user.id, @another_user.id] } }
      expect(response.status).to eq(302)
    end
    it 'グループオーナーでログインしてupdateアクションにリクエストすると詳細画面に遷移する' do
      sign_in @user
      put group_path(@group),
          params: { group: { name: 'test01', introduction: 'test', owner_id: @user.id, user_ids: [@user.id, @another_user.id] } }
      expect(response).to redirect_to group_path(@group)
    end
    it 'グループオーナー以外でログインしてupdateアクションにリクエストするとレスポンスにステータスコード302が返ってくる' do
      sign_in @another_user
      put group_path(@group)
      expect(response.status).to eq(302)
    end
    it 'ログインしていない状態でupdateアクションにリクエストするとレスポンスにステータスコード302が返ってくる' do
      put group_path(@group)
      expect(response.status).to eq(302)
    end
    it 'グループオーナー以外でログインしてupdateアクションにリクエストすると詳細画面に遷移する' do
      sign_in @another_user
      put group_path(@group)
      expect(response).to redirect_to group_path(@group)
    end
    it 'ログインしていない状態でupdateアクションにリクエストするとログイン画面に遷移する' do
      put group_path(@group)
      expect(response).to redirect_to '/users/sign_in'
    end
  end
end
