# 組写真投稿アプリ
### 撮影した写真を共有できるアプリケーションを作成しました。写真の投稿と投稿に対するコメントで、写真を通したコミュケーションを提供するアプリケションです。
<br>

## 利用方法
### URL：https://photo-room.herokuapp.com/
### Basic認証
- ID : admin
- Pass : 1111
### テスト用アカウント
- メールアドレス : test@com
- パスワード : test111111

<br>

### 動作確認方法
#### WebブラウザGoogle Chromeの最新版を利用してアクセスしてください。
#### ただしデプロイ等で接続できないタイミングもございます。その際は少し時間をおいてから接続してください。
#### 接続先およびログイン情報については、上記の通りです。
#### 同時に複数の方がログインしている場合に、ログインできない可能性があります。
<br>

#### 投稿方法
- テストアカウントでログイン→トップページからNew Postボタン押下→投稿情報入力→写真投稿
#### コメント方法
- テストアカウントでログイン→トップページから写真選択→コメントボタン押下→コメント投稿
確認後、ログアウト処理をお願いします。


<br>

## 開発コンセプト
### 目指した課題解決
- 写真を趣味としている個人もしくはグループにとって、撮影した写真に対する他者評価を手軽に得られる機会がない、また、同じように趣味で写真をやっている他者の写真を手軽に見られる機会がないといった課題があります。
- 写真を共有できるコミュニケーションツールがあれば、写真のスキル向上と他者とのコミュニケーションを通した多様な楽しみ方の発見につながると考えました。複数人で集まって撮影会や講評会を行ったりすることが難しい場面でも、アプリを通して共有とフィードバックが可能となります。個人活動になりがちな写真という趣味の可能性を広げることにもつながると考えました。
### 洗い出した要件
- 個人で写真を投稿できること
- グループで写真を投稿できること
- 投稿した写真にコメントができること

<br>

## 実装概要
### 実装済み機能について
- ユーザー管理機能
- グループ管理機能
- 写真投稿機能（個人・グループ）
- コメント機能
### 実装予定の機能について
- グループチャット機能

<br>

## データベース設計
ER図
[![Image from Gyazo](https://i.gyazo.com/4fa8d0edf9f58a6c17e01d9e2b5b5e57.png)](https://gyazo.com/4fa8d0edf9f58a6c17e01d9e2b5b5e57)


## users テーブル

| Column               | Type       | Options                  |
| -------------------- | ---------- | -------------------------|
| nickname             | string     | null: false              |
| email                | string     | null: false,unique: true |
| encrypted_password   | string     | null: false              |
| image                | string     | null: false              |
| last_name            | string     | null: false              |
| first_name           | string     | null: false              |
| main_camera          | string     | null: false              |
| prefecture_id        | integer    | null: false              |
| camera_experience_id | integer    | null: false              |

### Association
- has_many :posts
- has_many :group_users
- has_many :groups, through: :group_users
- has_many :comments

## group テーブル

| Column        | Type       | Options                        |
| ------------- | ---------- | -------------------------------|
| name          | string     | null: false                    |
| introduction  | string     | null: false                    |
| owner_id      | integer    | null: false                    |

### Association
- has_many :group_users
- has_many :users, through: :group_users
- has_many :group_posts

## group_users テーブル

| Column   | Type       | Options                            |
| -------- | ---------- | -----------------------------------|
| user     | references | null: false, foreign_key: true     |
| group    | references | null: false, foreign_key: true     |

### Association
- belongs_to :user
- belongs_to :group

## posts テーブル

| Column             | Type       | Options                        |
| ------------------ | ---------- | -------------------------------|
| title              | string     | null: false                    |
| text               | text       | null: false                    |
| group_post_id      | integer    | foreign_key: true              |
| action             | string     | default: '', null: false       |
| user               | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- belongs_to :group_post
- has_many :comments
- has_many_attached :images

## group_posts テーブル

| Column             | Type       | Options                        |
| ------------------ | ---------- | -------------------------------|
| group_title        | string     | null: false                    |
| group_text         | text       | null: false                    |
| group_id           | integer    | null: false, foreign_key: true |

### Association
- has_many :posts
- belongs_to :group

## comments テーブル

| Column      | Type       | Options                               |
| ----------- | ---------- | --------------------------------------|
| text        | string     | null: false                           |
| commentable | references | null: false, polymorphic: true        |
| user        | references | null: false, foreign_key: true        |

### Association
- belongs_to :commentable
- belongs_to :user

<br>

## ローカルでの動作方法
- 
## 開発環境
- Ruby/Ruby on Rails/MySQL/GitHub/AWS/Visual Studio Code