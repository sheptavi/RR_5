module Api
  class ApiController < ApplicationController
    include WorkImage
    skip_before_action :verify_authenticity_token
    
def next_image
  current_index = params[:index].to_i
  theme_id = params[:theme_id].to_i
  length = params[:length].to_i

  new_image_index = next_index(current_index, length)
  data = show_image(theme_id, new_image_index)

  render json: {
    new_image_index: data[:index],
    name: data[:name],
    image_url: data[:file],
    image_id: data[:image_id],
    user_valued: data[:user_valued],
    common_ave_value: data[:common_ave_value],
    value: data[:value]
  }
end

def prev_image
  current_index = params[:index].to_i
  theme_id = params[:theme_id].to_i
  length = params[:length].to_i

  new_image_index = prev_index(current_index, length)
  data = show_image(theme_id, new_image_index)

  render json: {
    new_image_index: data[:index],
    name: data[:name],
    image_url: data[:file],
    image_id: data[:image_id],
    user_valued: data[:user_valued],
    common_ave_value: data[:common_ave_value],
    value: data[:value]
  }
end    
    private
    
    def next_index(index, length)
      return 0 if length == 0
      index < length - 1 ? index + 1 : 0
    end
    
    def prev_index(index, length)
      return 0 if length == 0
      index > 0 ? index - 1 : length - 1
    end
  end
end
