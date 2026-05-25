class Theme < ApplicationRecord
  has_many :images, dependent: :destroy

 def translated_name
   I18n.t("themes_translations.#{id}", default: name)
 end  
end
