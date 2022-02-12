class GroupPost < ApplicationRecord
  has_many :posts
  belongs_to :group
end
