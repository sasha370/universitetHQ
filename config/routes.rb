Rails.application.routes.draw do
  # Пути для Users провисанные через Devise ( автоматически при установке)
  devise_for :users
  # все пути для Курсов проаиснные генератором ысфаащдв
  resources :courses

  root 'home#index'
end
