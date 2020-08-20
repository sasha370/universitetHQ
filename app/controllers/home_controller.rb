class HomeController < ApplicationController
  # Скипаем провеку на вход для Главной страницы
  skip_before_action :authenticate_user!, only: [:index]

  def index
    # отображаем список из 3х курсов
    @courses = Course.all.limit(3)
<<<<<<< Updated upstream
=======
    # Все Подписки, у которых есть отзывы, 3 последнихб сортированы порейтингу
    @latest_good_reviews = Enrollment.reviewed.latest_good_reviews
    # Список самых свежих курсов (логику перенесли в Модель Courses)
    @latest = Course.latest
    # Список самых Лучших курсов
    @top_rated = Course.top_rated
    # Список Самых популярных курсов
    @popular = Course.popular
    # Мои курсы, Продолжить обучение
    @purchased_courses = Course.joins(:enrollments).where(enrollments: {user: current_user}).order( created_at: :desc).limit(3)
>>>>>>> Stashed changes

    # Список самых свежих курсов
    @latest_courses = Course.all.limit(3).order(created_at: :desc)
  end

  # Собираем все активностипо разделу статьи
  def activity
    @activities = PublicActivity::Activity.all
  end
end
