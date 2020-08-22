class ChartsController < ApplicationController
  # Контроллер для графиков.
  # Чтобы постоянно он-лайн не пересчитывать Юзеров, уроки и т.д. создали этот контроллер,
  # который будет считать все на сервере и отправлять в браузер подготовленный JSON

  def users_per_day
    render json: User.group_by_day(:created_at).count
  end

  def enrollments_per_day
    render json: Enrollment.group_by_day(:created_at).count
  end

  def course_popularity
    render json: Enrollment.joins(:course).group(:'courses.title').count
  end

end
