class ValuesController < ApplicationController
  def index
    @values = Value.all.includes(:user, :image)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end
end
