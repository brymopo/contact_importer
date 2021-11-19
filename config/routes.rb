Rails.application.routes.draw do
  root "static_pages#index"
  devise_for :users
  resources :csv_files
  resources :contacts
  resources :contact_errors
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
