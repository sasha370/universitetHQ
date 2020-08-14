Rails.application.routes.draw do
  resources :enrollments
  # Пути для Users провисанные через Devise ( автоматически при установке)
  devise_for :users

  # все пути для Курсов проаиснные генератором
  # Уроки идут в URL после курса в виде courses/lesson/22
  resources :courses do
    resources :lessons
  end

  resources :users, only: [:index, :edit, :show, :update]

  get 'home/index'
  # Для отслеживания активности на сайте в разделе Courses
  get 'home/activity'
  root 'home#index'
end
