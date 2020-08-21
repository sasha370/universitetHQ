Rails.application.routes.draw do
  # Пути для Users провисанные через Devise ( автоматически при установке)
  devise_for :users

  # все пути для Курсов проаиснные генератором
  # Уроки идут в URL после курса в виде courses/lesson/22
  resources :courses do
    # Запрос сбрасываем на подобранную коллекцию ( отображает список Купленных курсов, и тех что ожидают отзывы)
    get :purchased, :pending_review, :created, on: :collection
    resources :lessons
    # Подписка может быть только создана
    resources :enrollments, only: [:new, :create, :index]
  end

  resources :users, only: [:index, :edit, :show, :update]


  resources :enrollments do
    # Запрос сбрасывается на доп.метод, который отображает всех студентов текущего преподователя
    get :my_students, on: :collection
  end

  get 'home/index'
  # Статистика
  get 'analytics', to: 'home#analytics'
  # Для отслеживания активности на сайте в разделе Courses
  get 'activity', to: 'home#activity'
  root 'home#index'


end
