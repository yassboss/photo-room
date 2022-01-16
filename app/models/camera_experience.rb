class CameraExperience < ActiveHash::Base
  self.data = [
    { id: 1, name: '---' },
    { id: 2, name: '1年未満' },
    { id: 3, name: '1〜3年'},
    { id: 4, name: '4〜5年'},
    { id: 5, name: '5〜10年'},
    { id: 6, name: '10〜15年'},
    { id: 7, name: '15〜20年'},
    { id: 8, name: '20年以上'}
  ]

  include ActiveHash::Associations
  has_many :users
end