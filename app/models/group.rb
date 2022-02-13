class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users
  has_many :group_posts

  with_options presence: true do
    validates :name, :introduction, :owner_id
  end
end
