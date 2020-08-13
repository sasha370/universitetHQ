Rails.application.routes.draw do
  # Пути для Users провисанные через Devise ( автоматически при установке)
  devise_for :users
  # все пути для Курсов проаиснные генератором ысфаащдв
  resources :courses
  resources :users, only: [:index]

  root 'home#index'

  # Для отслеживания активности на сайте в разделе Courses
  get 'home/activity'
end
