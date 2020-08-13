class ApplicationController < ActionController::Base
  # Перед посещением любой страницы мы должны аутентифицировать ползователя
  before_action :authenticate_user!

  # Настройка для поиска в Навбаре
  before_action :set_global_variables
  def set_global_variables
    @ransack_courses = Course.ransack(params[:courses_search], search_key: :courses_search)
  end

end
