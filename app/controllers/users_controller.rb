class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def index
    @users = User.all
  end
  
  def show
    # @user уже установлен через set_user
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      sign_in @user
      redirect_to work_path, notice: "Добро пожаловать, #{@user.name}!"
    else
      render 'new'
    end
  end
  
  def edit
    # @user уже установлен через set_user
  end
  
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Профиль обновлён'
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    redirect_to users_path, notice: 'Пользователь удалён'
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
