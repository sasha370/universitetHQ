Rails.application.routes.draw do
  devise_for :users, controllers: {
      registrations: 'users/registrations',
      omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :courses, except: [:edit] do # Edit реализован через Wizard
    get :purchased, :pending_review, :created, :unapproved, on: :collection
    resources :lessons do
      put :sort
      resources :comments
      member do
        delete :delete_video
      end
    end
    resources :enrollments, only: [:new, :create, :index]

    member do
      get :analytics
      patch :approve
      patch :unapprove
    end
    resources :course_wizard, controller: 'courses/course_wizard'
  end

  resources :users, only: [:index, :edit, :show, :update]
  resources :youtube, only: :show
  resources :tags, only: [:create, :index, :destroy]


  resources :enrollments do
    get :my_students, on: :collection
    member do
      get :certificate
    end
  end

  get 'home/index'
  get 'analytics', to: 'home#analytics'
  get 'privacy_policy', to: 'home#privacy_policy'

  namespace :charts do
    get 'users_per_day'
    get 'enrollments_per_day'
    get 'course_popularity'
    get 'money_makers'
  end

  get 'activity', to: 'home#activity'
  root 'home#index'
end
