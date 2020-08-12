class UsersController < ApplicationController

  def index
    # Выбираем всех узеров и сортируем по дате создания
    # @users = User.all.order(created_at: :desc)
    # Методы из gem ransack, которые формирует поисковую выдачу
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true)
  end

end
