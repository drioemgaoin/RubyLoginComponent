Rails.application.routes.draw do
  get 'home/index'

  get 'new_sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#sign_in'
  delete 'sign_out', to: 'sessions#sign_out'

  root :to => 'home#index'

end
