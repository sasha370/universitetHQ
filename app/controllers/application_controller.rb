class ApplicationController < ActionController::Base
  # Перед посещением любой страницы мы должны аутентифицировать ползователя
  before_action :authenticate_user!

  # подключаем пагинатор
  include Pagy::Backend


  # После любого действия "трогаем запись" в БД, чтобы обновить время
  # далее используем это, чтобы отслеживать он-лайн ли пользователь
  after_action :user_activity

  # подключаем гем для раздачи прав на просмотр контента
  include Pundit
  protect_from_forgery
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized



  # Для того, чтобы получить current_usera в PublicActivity нужно подключить данный контроллер
  include PublicActivity::StoreController

  # Настройка для поиска в Навбаре
  before_action :set_global_variables
  def set_global_variables
    @ransack_courses = Course.ransack(params[:courses_search], search_key: :courses_search)
  end

  private

  def user_not_authorized  #pundit
    flash[:alert] =  " You are not authorized to perfome this action"
    redirect_to(request.referrer || root_path)
  end

  # Трогаем запись в БД , чтобы обновить время updated_at
  def user_activity
    current_user.try :touch
  end

end
