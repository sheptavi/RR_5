class Image < ApplicationRecord
  belongs_to :theme
  has_many :values, dependent: :destroy
  has_many :users, through: :values
end
