class GroupUser < ApplicationRecord
  belongs_to :group
  belongs_to :user

  with_options presence: true do
    validates :user_id, :group_id
  end
end
