class Value < ApplicationRecord
  belongs_to :user
  belongs_to :image
  
  validates :user_id, uniqueness: { scope: :image_id, message: "уже оценил это изображение" }
end
