class ApplicationController < ActionController::Base
  include SessionsHelper
  
  # Перед каждым запросом устанавливаем язык
  before_action :set_locale
  
  private
  
  def set_locale
    # Берём язык из параметров URL (например, ?locale=en)
    locale = params[:locale]
    
    # Если язык есть в списке доступных — устанавливаем его
    if locale && I18n.available_locales.include?(locale.to_sym)
      I18n.locale = locale
    else
      # Иначе используем язык по умолчанию
      I18n.locale = I18n.default_locale
    end
    
    # Чтобы ссылки сохраняли язык
    Rails.application.routes.default_url_options[:locale] = I18n.locale
  end
  
  # Добавляем параметр locale во все сгенерированные URL
  def default_url_options
    { locale: I18n.locale }
  end
end
