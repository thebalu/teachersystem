Rails.application.routes.draw do

  devise_for :teachers
  root to: 'courses#index'

  resources :courses do
    resources :sessions
  end
  post 'courses/signup', to: 'courses#signup', defaults: {format: 'json'}, as: 'signup'
  post 'courses/id_signup', to:'courses#id_signup', defaults: {format: 'json'}, as:'id_signup'
  post 'courses/drop',to: 'courses#drop', defaults: {format: 'json'}, as:'drop'
  get  'student_signups', to: 'courses#student_signups', defaults: {format: 'json'}

  get 'teachers/:id', to: 'teachers#show', as: 'show_teacher'
  get 'teachers', to: 'teachers#index', as:'teachers'
  get 'profile', to: 'teachers#profile', as: 'profile'
  get 'profile/edit', to: 'teachers#edit', as:'edit_teacher'
  patch 'teachers', to:'teachers#update', as:'teacher'
  get 'check_teacher', to:'teachers#check_teacher'

  post 'teachers/login_teacher',to:'teachers#login_teacher'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
