Rails.application.routes.draw do

  devise_for :teachers
  root to: 'courses#index'

  resources :courses do
    resources :sessions
  end
  post 'courses/signup', to: 'courses#signup', defaults: {format: 'json'}, as: 'signup'
  post 'courses/drop',to: 'courses#drop', defaults: {format: 'json'}, as:'drop'
  get  'student_signups', to: 'courses#student_signups', defaults: {format: 'json'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
