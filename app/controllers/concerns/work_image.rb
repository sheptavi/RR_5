module WorkImage
  extend ActiveSupport::Concern
  include WorkHelper

  def show_image(theme_id, image_index)
    theme_images = Image.where(theme_id: theme_id)
    current_user_id = current_user&.id || 1
    
    one_image_attr = theme_images[image_index].attributes
    image_id = one_image_attr["id"]
    
    user_valued = Value.exists?(user_id: current_user_id, image_id: image_id) ? 1 : 0
    value = 0
    common_ave_value = 0
    
    if user_valued == 1
      value_record = Value.find_by(user_id: current_user_id, image_id: image_id)
      value = value_record&.value || 0
      common_ave_value = Image.find(image_id).ave_value || 0
    end
    
    {
      index: image_index,
      theme_id: theme_id,
      images_arr_size: theme_images.size,
      image_id: image_id,
      name: one_image_attr["name"],
      file: one_image_attr["file"],
      user_valued: user_valued,
      value: value,
      common_ave_value: common_ave_value
    }
  end
end
