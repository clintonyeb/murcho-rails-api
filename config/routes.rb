Rails.application.routes.draw do
  namespace :v1 do
    
    # Concerns
    concern :trashable do
      delete :move_to_trash
      put :move_from_trash
      post :move_bulk_to_trash, on: :collection
    end

    # Resources
    resources :churches
    resources :users
    resources :person_profiles
    resources :people
  
    # Custom routes
    post 'authentication', to: 'authentication#create'
    post 'get_user_info', to: 'users#get_user_info'

    get 'total_people', to: 'people#total_people'
  end
end