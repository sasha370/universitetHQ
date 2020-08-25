Rails.application.routes.draw do
  # Пути для Users провисанные через Devise ( автоматически при установке)
  devise_for :users

  # все пути для Курсов проаиснные генератором
  # Уроки идут в URL после курса в виде courses/lesson/22
  resources :courses do
    # Запрос сбрасываем на подобранную коллекцию ( отображает список Купленных курсов, и тех что ожидают отзывы)
    get :purchased, :pending_review, :created, :unapproved, on: :collection
    resources :lessons do
      put :sort # метод для сортировки уроков внутри курса
      member do
        # переопределяем стандартный метод delete
        delete :delete_video
      end
    end
    # Подписка может быть только создана
    resources :enrollments, only: [:new, :create, :index]

    # Для обработки события Подтверждения курса Админом
    # Метод member передает ID курса и подмешивает в экшн Show дополнение
    member do
      get :analytics
      patch :approve
      patch :unapprove
    end
  end

  resources :users, only: [:index, :edit, :show, :update]


  resources :enrollments do
    # Запрос сбрасывается на доп.метод, который отображает всех студентов текущего преподователя
    get :my_students, on: :collection
  end

  get 'home/index'
  # Статистика
  get 'analytics', to: 'home#analytics'

  # Вместо перечисления всех Get отдельно, создаем Пространсво имен для Charts
  namespace :charts do
    get 'users_per_day'
    get 'enrollments_per_day'
    get 'course_popularity'
    get 'money_makers'
  end

  # Для отслеживания активности на сайте в разделе Courses
  get 'activity', to: 'home#activity'
  root 'home#index'


end
