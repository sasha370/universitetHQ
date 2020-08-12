class UsersController < ApplicationController

  def index
    # Выбираем всех узеров и сортируем по дате создания
    @users = User.all.order(created_at: :desc)
  end


end
