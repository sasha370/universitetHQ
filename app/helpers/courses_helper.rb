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


end
