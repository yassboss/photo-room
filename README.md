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

## group_users テーブル

| Column   | Type       | Options                        |
| -------- | ---------- | -------------------------------|
| user     | references | null: false, foreign_key: true |
| group    | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- belongs_to :group

## posts テーブル

| Column             | Type       | Options                        |
| ------------------ | ---------- | -------------------------------|
| title              | string     | null: false                    |
| text               | text       | null: false                    |
| theme_id           | integer    |                                |
| action             | string     | default: '', null: false       |
| user               | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- has_many :comments
- has_many :post_units
- has_many :units, through: :post_units
- has_many_attached :images

## units テーブル

| Column             | Type       | Options              |
| ------------------ | ---------- | ---------------------|
| unit_title         | string     | null: false          |
| unit_text          | text       | null: false          |
| group_id           | integer    | null: false          |

### Association
- has_many :post_units
- has_many :posts, through: :post_units

## post_units テーブル

| Column   | Type       | Options                        |
| -------- | ---------- | -------------------------------|
| post     | references | null: false, foreign_key: true |
| unit     | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- belongs_to :group

## comments テーブル

| Column   | Type       | Options                        |
| -------- | ---------- | -------------------------------|
| text     | string     | null: false                    |
| post     | integer    | null: false, foreign_key: true |
| user     | integer    | null: false, foreign_key: true |

### Association
- belongs_to :item
- belongs_to :user