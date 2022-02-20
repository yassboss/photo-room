# テーブル設計

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

| Column      | Type       | Options                                           |
| ----------- | ---------- | --------------------------------------------------|
| text        | string     | null: false                                       |
| commentable | references | null: false, foreign_key: true, polymorphic: true |
| user        | references | null: false, foreign_key: true                    |

### Association
- belongs_to :commentable
- belongs_to :user