class ThemesController < ApplicationController
  def index
    @themes = Theme.all
  end

  def show
    @theme = Theme.find(params[:id])
  end

  def new
    @theme = Theme.new
  end

  def create
    @theme = Theme.new(theme_params)
    if @theme.save
      redirect_to themes_path, notice: 'Тема успешно создана.'
    else
      render :new
    end
  end

  def edit
    @theme = Theme.find(params[:id])
  end

  def update
    @theme = Theme.find(params[:id])
    if @theme.update(theme_params)
      redirect_to themes_path, notice: 'Тема обновлена.'
    else
      render :edit
    end
  end

  def destroy
    @theme = Theme.find(params[:id])
    @theme.destroy
    redirect_to themes_path, notice: 'Тема удалена.'
  end

  private

  def theme_params
    params.require(:theme).permit(:name, :qty_items)
  end
end
