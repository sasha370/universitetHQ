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
        link_to " Keep leaning ", course_path(course)

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

  def rewiew_button(course)
    # выбираем все подписки у данного курса, где пользователь current_user
    user_course = course.enrollments.where(user: current_user)
    # только зарегистрированные могут видеть
    if current_user
      # если существует запись, где текущий пользователь имеет подписку на данный курс
      if user_course.any?
        # проверяем есть в этой подписки отзывы или оценки, если они пустые, то показываем кнопку
        if user_course.pending_review.any?
          # кнопка оставить отзыв
          link_to "Add a review", edit_enrollment_path(user_course.first)
        else
          # если рейтинг уж проставле, то благодарим
          link_to "Thanks for Review", enrollment_path(user_course.first)
        end
      end
    end
  end
end
