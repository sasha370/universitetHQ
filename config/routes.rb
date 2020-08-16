Rails.application.routes.draw do
  # Пути для Users провисанные через Devise ( автоматически при установке)
  devise_for :users

  # все пути для Курсов проаиснные генератором
  # Уроки идут в URL после курса в виде courses/lesson/22
  resources :courses do
    resources :lessons
    # Подписка может быть только создана
    resources :enrollments, only: [:new, :create, :index]
  end

  resources :users, only: [:index, :edit, :show, :update]

  resources :enrollments
  get 'home/index'
  # Для отслеживания активности на сайте в разделе Courses
  get 'activity', to: 'home#activity'
  root 'home#index'
end
