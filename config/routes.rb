Rails.application.routes.draw do

  devise_for :teachers
  root to: 'courses#index'

  resources :courses do
    resources :sessions
  end
  post 'courses/signup', to: 'courses#signup', defaults: {format: 'json'}, as: 'signup'
  post 'courses/drop',to: 'courses#drop', defaults: {format: 'json'}, as:'drop'
  get  'student_signups', to: 'courses#student_signups', defaults: {format: 'json'}

  get 'profile', to: 'teachers#show', as: 'show_teacher'
  get 'profile/edit', to: 'teachers#edit', as:'edit_teacher'
  patch 'teachers', to:'teachers#update', as:'teacher'
  get 'check_teacher', to:'teachers#check_teacher'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
