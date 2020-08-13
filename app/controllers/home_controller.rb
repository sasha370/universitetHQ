class HomeController < ApplicationController
  # Скипаем провеку на вход для Главной страницы
  skip_before_action :authenticate_user!, only: [:index]

  def index
    # отображаем список из 3х курсов
    @courses = Course.all.limit(3)

    # Список самых свежих курсов
    @latest_courses = Course.all.limit(3).order(created_at: :desc)
  end

  # Собираем все активностипо разделу статьи
  def activity
    @activities = PublicActivity::Activity.all
  end
end
