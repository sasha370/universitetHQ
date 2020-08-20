module CoursesHelper

  # Кнопка подписки,
  def enrollment_button(course)
    # Если пользователь зарегистрован
    if current_user
      # если текущий пользователь = владельцу курса
      if course.user == current_user
        link_to "You created this course. View analitics", course_path(course)
        # если текущий пользователь уже имеет подписку
      elsif course.enrollments.where(user: current_user).any?
        # то отображаем его прогресс в процентах и даем ссылку на курс
        link_to course_path(course) do
          "<i class='fa fa-spinner'></i>".html_safe + " " +
              number_to_percentage(course.progress(current_user), precision: 0)
        end

        # Отстались только новые юзеры не связанны с текущим курсом
        # Если Курс платный, то отправляем на страницу Подписки
      elsif course.price > 0
        link_to number_to_currency(course.price), new_course_enrollment_path(course), class: 'btn btn-success'
      else
        link_to 'Free', new_course_enrollment_path(course), class: 'btn btn-success'
      end
    else
      # Если не зарегистрирован, то перенаправляем на страницу курса
      link_to "Check price", course_path(course), class: 'btn btn-ms btn-success'
    end
  end

  def review_button(course)
    # выбираем все подписки у данного курса, где пользователь current_user
    user_course = course.enrollments.where(user: current_user)
    # только зарегистрированные могут видеть
    if current_user
      # если существует запись, где текущий пользователь имеет подписку на данный курс
      if user_course.any?
        # проверяем есть в этой подписки отзывы или оценки, если они пустые, то показываем кнопку
        if user_course.pending_review.any?
          # кнопка оставить отзыв
          link_to edit_enrollment_path(user_course.first) do
            "<i class='text-warning fa fa-star'></i>".html_safe + " " +
                "<i class='text-dark fa fa-question'></i>".html_safe + " " +
                "Add a review"
          end
        else
          # если рейтинг уж проставле, то благодарим
          link_to enrollment_path(user_course.first) do
            "<i class='text-warning fa fa-star'></i>".html_safe + " " +
                "<i class='fa fa-check'></i>".html_safe + " " +
                "Thanks for Review"
          end
        end
      end
    end
  end
end
