class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images, dependent: :destroy
  has_many :comments, as: :commentable
  validates :title, presence: true
  validates :text, presence: true
  validates :action, presence: true
  validates :images, presence: true
  validates :images, length: { minimum: 1, maximum: 5, message: 'は1枚以上5枚以下にしてください' }
  validates :user_id, presence: true
end
