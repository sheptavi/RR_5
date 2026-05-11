class User < ApplicationRecord
  has_many :values, dependent: :destroy
  has_many :images, through: :values
end
