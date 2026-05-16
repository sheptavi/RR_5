class WorkController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:rate_image, :next_image, :prev_image]
  
  def index
    @selected_theme = "Выберите тему для оценки"
    @selected_image_name = "Изображение не выбрано"
    @values_qty = Value.count
    @current_user_id = 1  # Временный пользователь
  end
  
  def choose_theme
    @themes = Theme.where.not(id: 1).pluck(:name, :name)  # Все темы, кроме "Нет темы"
    render json: { themes: @themes }
  end
  
def display_theme
  theme_name = params[:theme]
  theme = Theme.find_by(name: theme_name)
  
  if theme.present?
    @theme_images = Image.where(theme_id: theme.id)
    @current_index = 0
    @image = @theme_images.first
    
    if @image.nil?
      render json: { error: "В этой теме нет изображений" } and return
    end
    
    @user_value = Value.find_by(user_id: 1, image_id: @image.id)&.value || 0
    
    render json: {
      theme_name: theme.name,
      image_name: @image.name,
      image_url: @image.file,
      image_id: @image.id,
      total_images: @theme_images.count,
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
    user_id = 1  # Временный пользователь
    
    # Сохраняем или обновляем оценку
    rating = Value.find_or_initialize_by(user_id: user_id, image_id: image_id)
    rating.value = value
    rating.save!
    
    # Пересчитываем среднюю оценку для изображения
    image = Image.find(image_id)
    avg = image.values.average(:value)
    image.update(ave_value: avg)
    
    render json: { success: true, common_value: avg.round(2) }
  end
  
  def next_image
    theme_name = params[:theme_name]
    current_index = params[:current_index].to_i
    theme = Theme.find_by(name: theme_name)
    
    if theme.present?
      images = Image.where(theme_id: theme.id)
      new_index = (current_index + 1) % images.count
      image = images[new_index]
      user_value = Value.find_by(user_id: 1, image_id: image.id)&.value || 0
      
      render json: {
        image_name: image.name,
        image_url: image.file,
        image_id: image.id,
        current_index: new_index,
        user_value: user_value,
        common_value: image.ave_value || 0
      }
    else
      render json: { error: "Тема не найдена" }, status: 404
    end
  end
  
  def prev_image
    theme_name = params[:theme_name]
    current_index = params[:current_index].to_i
    theme = Theme.find_by(name: theme_name)
    
    if theme.present?
      images = Image.where(theme_id: theme.id)
      new_index = (current_index - 1) % images.count
      image = images[new_index]
      user_value = Value.find_by(user_id: 1, image_id: image.id)&.value || 0
      
      render json: {
        image_name: image.name,
        image_url: image.file,
        image_id: image.id,
        current_index: new_index,
        user_value: user_value,
        common_value: image.ave_value || 0
      }
    else
      render json: { error: "Тема не найдена" }, status: 404
    end
  end
end
