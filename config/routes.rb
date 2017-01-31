Rails.application.routes.draw do
  get 'home/index'

  get 'new_sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#sign_in'
  delete 'sign_out', to: 'sessions#sign_out'

  get 'new_sign_up', to: 'registrations#new'
  post 'sign_up', to: 'registrations#sign_up'

  get 'new_password', to: 'passwords#new'
  post 'password', to: 'passwords#create'
  match 'users/password/edit', to: 'passwords#edit',  via: [:get]
  put 'password', to: 'passwords#update'

  root :to => 'home#index'
end
