Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :departments, only: :index do
    collection do
      get :print
      post :upload
    end
  end


  root to: 'departments#index'
end
