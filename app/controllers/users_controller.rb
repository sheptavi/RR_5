class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @user_values = @user.values.includes(:image).order(created_at: :desc)
  end
  
  def new
    @user = User.new
  end
  
def create
  @user = User.new(user_params)
  
  if @user.save
    sign_in @user
    
    # Для нового пользователя не создаём никаких оценок
    # Оценки будут появляться только когда он сам их поставит
    
    redirect_to work_path, notice: "Добро пожаловать, #{@user.name}!"
  else
    render 'new'
  end
end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
