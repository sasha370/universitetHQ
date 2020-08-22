class HomeController < ApplicationController
  # Скипаем провеку на вход для Главной страницы
  skip_before_action :authenticate_user!, only: [:index]

  def index
    # отображаем список из 3х курсов
    @courses = Course.all.limit(3)

    # Все Подписки, у которых есть отзывы, 3 последнихб сортированы порейтингу
    @latest_good_reviews = Enrollment.reviewed.latest_good_reviews
    # Список самых свежих курсов (логику перенесли в Модель Courses)
    @latest = Course.latest
    # Список самых Лучших курсов
    @top_rated = Course.top_rated
    # Список Самых популярных курсов
    @popular = Course.popular
    # Мои курсы, Продолжить обучение
    @purchased_courses = Course.joins(:enrollments).where(enrollments: { user: current_user }).order(created_at: :desc).limit(3)


    # Список самых свежих курсов
    @latest_courses = Course.all.limit(3).order(created_at: :desc)
  end

  # Собираем все активностипо разделу статьи
  def activity
    if current_user.has_role?(:admin)
      @activities = PublicActivity::Activity.all
    else
      redirect_to root_path, alert: 'You are not authorized to access this page'
    end
  end

  # Вывод статистики
  def analytics
    if current_user.has_role?(:admin)
      # @users = User.all
      # @enrollments = Enrollment.all
      # @courses = Course.all
    else
      redirect_to root_path, alert: 'You are not authorized to access this page'
    end
  end
end
