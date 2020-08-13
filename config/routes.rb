Rails.application.routes.draw do
  resources :lessons
  # Пути для Users провисанные через Devise ( автоматически при установке)
  devise_for :users
  # все пути для Курсов проаиснные генератором ысфаащдв
  resources :courses
  resources :users, only: [:index, :edit, :show, :update]

  root 'home#index'

  # Для отслеживания активности на сайте в разделе Courses
  get 'home/activity'
end
