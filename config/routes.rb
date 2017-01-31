Rails.application.routes.draw do
  get 'home/index'

  get 'new_sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#sign_in'
  delete 'sign_out', to: 'sessions#sign_out'

  get 'new_sign_up', to: 'registrations#new'
  post 'sign_up', to: 'registrations#sign_up'

  root :to => 'home#index'

end
