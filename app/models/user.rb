class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture
  belongs_to :camera_experience
  has_many :group_users
  has_many :groups, through: :group_users
  has_many :posts
  has_many :comments
  has_one_attached :avatar

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze

  validates_format_of :password, with: VALID_PASSWORD_REGEX, message: 'must be containing both letters and numbers',
                                 allow_blank: true

  validates :nickname, :last_name, :first_name, :main_camera, :avatar, presence: true
  validates :prefecture_id, :camera_experience_id, numericality: { other_than: 1, message: "can't be blank" }
end
