class GroupPost < ApplicationRecord
  has_many :posts, dependent: :destroy
  accepts_nested_attributes_for :posts, allow_destroy: true, reject_if: :all_blank
  belongs_to :group
end
