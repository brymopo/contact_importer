Rails.application.routes.draw do
  root "static_pages#index"
  devise_for :users
  resources :csv_files
  resources :contacts
  resources :contact_errors
end
