class GroupPost < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  accepts_nested_attributes_for :posts, allow_destroy: true, reject_if: :all_blank
  belongs_to :group
  validates :group_title, presence: true
  validates :group_text, presence: true
end
