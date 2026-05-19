class Image < ApplicationRecord
  belongs_to :theme
  has_many :values, dependent: :destroy
  has_many :users, through: :values
  
  scope :theme_images, ->(theme_id) {
    select(:id, :name, :file, :ave_value).where(theme_id: theme_id)
  }
  
  def translated_name
    I18n.t("images.#{id}", default: name)
  end
end
