class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def index
    # Выбираем всех узеров и сортируем по дате создания
    # @users = User.all.order(created_at: :desc)
    # Методы из gem ransack, которые формирует поисковую выдачу
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true)
  end


  def edit

  end

  def show

  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "User #{@user.email} was successfully update."
    else
      render :edit
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit({ role_ids: [] })
  end
end
