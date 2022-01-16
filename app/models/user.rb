class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture
  belongs_to :camera_experience

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  mount_uploader :image, ImageUploader

  validates :nickname, :image, :last_name, :first_name, :main_camera, presence: true
  validates :prefecture_id, :camera_experience_id, numericality: { other_than: 1, message: "can't be blank" } 
end
