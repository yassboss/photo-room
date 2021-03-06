# アプリ名
### 組写真投稿アプリ Photo Room

![画像](https://user-images.githubusercontent.com/90130298/159275965-a89f06bd-1cd7-4929-b559-6c0eb45377ed.jpg)
<br>
<br>

# 概要
#### 撮影した写真を組写真として共有できるアプリケーションを作成しました。写真の投稿と投稿に対するコメントで、写真を通したコミュケーションを提供するアプリケションです。
##### ※組写真とは、複数の写真を組み合わせて、ストーリー性のある１つの作品にしたものです。
<br>

# 本番環境
https://photo-room.herokuapp.com/
### Basic認証
- ID : admin
- Pass : 1111
### ログイン情報（テスト用）
- メールアドレス : test@com
- パスワード : test111111

### 利用手順
- WebブラウザGoogle Chromeの最新版を利用してアクセスしてください。
    - ただしデプロイ等で接続できないタイミングもございます。その際は少し時間をおいてから接続してください。
    - 接続先およびログイン情報については、上記の通りです。
    - 同時に複数の方がログインしている場合に、ログインできない可能性があります。
- 投稿方法
    - テストアカウントでログイン→トップページからNew Postボタン押下→投稿情報入力→写真投稿
- コメント方法
    - テストアカウントでログイン→トップページから写真選択→コメントボタン押下→コメント投稿
確認後、ログアウト処理をお願いします。


<br>

# 制作背景（意図）
### 目指した課題解決
- 写真を趣味としている個人もしくはグループにとって、撮影した写真に対する他者評価を手軽に得られる機会がない、また、同じように趣味で写真をやっている他者の写真を手軽に見られる機会がないといった課題があります。
- 写真を共有できるコミュニケーションツールがあれば、写真のスキル向上と他者とのコミュニケーションを通した多様な楽しみ方の発見につながると考えました。複数人で集まって撮影会や講評会を行ったりすることが難しい場面でも、アプリを通して共有とフィードバックが可能となります。個人活動になりがちな写真という趣味の可能性を広げることにもつながると考えました。

### 洗い出した要件
- 個人で写真を投稿できること
- グループで写真を投稿できること
- 投稿した写真にコメントができること
- グループ内でチャットができること

<br>

### 実装済み機能について
- ユーザー管理機能
- グループ管理機能
- 写真投稿機能（個人・グループ）
- コメント機能
### 実装予定の機能について
- グループチャット機能

<br>

# DEMO
- トップページ（投稿閲覧）

![image](https://user-images.githubusercontent.com/90130298/159273823-a08fc447-c901-48ba-9be9-685fa7738ad7.gif)
<br>

- 新規投稿（個人）
![Image](https://user-images.githubusercontent.com/90130298/159505629-cac7efb8-0005-47e8-8bb3-8836e962563e.gif)
<br>

- 新規投稿（グループ）
![Image](https://user-images.githubusercontent.com/90130298/159505152-f9a6b72a-44ae-4c6c-85af-26281bb69e1e.gif)
<br>

- コメント投稿
![Image](https://user-images.githubusercontent.com/90130298/159506063-65f2723c-41b8-469d-8a5d-f8ae47069ab0.gif)
<br>
<br>

# 工夫したポイント
- 組写真投稿アプリとして、１つの投稿に複数枚の画像を保存できるようにしました。
- グループ投稿機能を設け、グループで同じテーマに沿った投稿を複数同時に行えるようにしました。
<br>
<br>

# 使用技術（開発環境）
## バックエンド
#### Ruby(2.6.5), Ruby on Rails(6.1.4)
## フロントエンド
#### HTML, CSS, Javascript
## データベース
#### MySQL(5.6.51), Sequel Pro
## ソース管理
#### GitHub, GitHubDesktop
## テスト
#### Rspec
## エディタ
#### VSCode
<br>
<br>

# DB設計
### ER図
[![Image from Gyazo](https://i.gyazo.com/8a1b6db900ec749fd92b54a88bfbc0ee.png)](https://gyazo.com/8a1b6db900ec749fd92b54a88bfbc0ee)


## users テーブル

| Column               | Type       | Options                  |
| -------------------- | ---------- | -------------------------|
| nickname             | string     | null: false              |
| email                | string     | null: false,unique: true |
| encrypted_password   | string     | null: false              |
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
- has_one_attached :avatar

## groups テーブル

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
| parent      | references | null: false, foreign_key: true        |
| user        | references | null: false, foreign_key: true        |

### Association
- belongs_to :commentable
- belongs_to :user

<br>

## ローカルでの動作方法
### 任意のディレクトリにアプリケーションをクローン
```
git clone https://github.com/yassboss/photo-room.git
```
### クローンしたアプリに移動
```
cd photo-room
```
### Gemインストール
```
bundle install
```
### JavaScriptのパッケージをインストール
```
yarn install
```
