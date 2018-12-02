Rails.application.routes.draw do
  namespace :v1 do

    # Resources
    
    resources :churches
    resources :users
    resources :person_profiles
    resources :people
    resources :person_groups
    resources :groups

    # Concerns
    # concern :trashable do
    #   delete :move_to_trash
    #   put :move_from_trash
    #   post :move_bulk_to_trash, on: :collection
    # end
  
    # Custom routes
    
    # POST routes
    post 'authentication', to: 'authentication#create'
    post 'get_user_info', to: 'users#get_user_info'

    # GET routes
    get 'total_people', to: 'people#total_people'
  end
end