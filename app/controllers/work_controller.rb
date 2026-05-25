class WorkController < ApplicationController
  include WorkImage
  skip_before_action :verify_authenticity_token, only: [:rate_image]
  
  def index
    @selected_theme = "Выберите тему для оценки"
    @selected_image_name = "Изображение не выбрано"
    @values_qty = Value.count
    @current_locale = I18n.locale
  end
  
  def choose_theme
    themes = Theme.where.not(id: 1)
    @themes = themes.map { |t| { id: t.id, name: t.translated_name } }
    render json: { themes: @themes }
  end  

  def display_theme
    theme_name = params[:theme]
    theme = Theme.find_by(name: theme_name)
    
    if theme.present?
      images = Image.where(theme_id: theme.id)
      @current_index = 0
      @image = images.first
      
      if @image.nil?
        render json: { error: "В этой теме нет изображений" } and return
      end
      
      user_id = current_user&.id || 1
      @user_value = Value.find_by(user_id: user_id, image_id: @image.id)&.value || 0
      
      render json: {
        theme_name: theme.name,
        theme_id: theme.id,
        image_name: @image.name,
        image_url: @image.file,
        image_id: @image.id,
        total_images: images.count,
        current_index: 0,
        user_value: @user_value,
        common_value: @image.ave_value || 0,
        values_qty: Value.count
      }
    else
      render json: { error: "Тема не найдена" }, status: 404
    end
  end
  
  def rate_image
    image_id = params[:image_id]
    value = params[:value].to_i
    
    # Ограничиваем оценку от 1 до 10
    value = 10 if value > 10
    value = 1 if value < 1
    
    user_id = current_user&.id || 1
    
    rating = Value.find_or_initialize_by(user_id: user_id, image_id: image_id)
    rating.value = value
    rating.save!
    
    image = Image.find(image_id)
    new_avg = image.values.average(:value)
    image.update(ave_value: new_avg.round(2))
    
    render json: { 
      success: true, 
      common_value: new_avg.round(2),
      image_id: image_id,
      user_value: value
    }
  end
end
