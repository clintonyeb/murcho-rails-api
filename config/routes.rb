Rails.application.routes.draw do
  namespace :v1 do

    # Resources
    
    resources :churches
    resources :users
    resources :person_profiles
    resources :people
    resources :groups
    resources :event_exceptions
    resources :event_instances
    resources :event_schemas
    resources :calendars

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
    post 'add_person_to_group', to: 'people#add_person_to_group'
    post 'add_people_to_groups', to: 'people#add_people_to_groups'
    post 'remove_person_groups', to: 'people#remove_person_groups'
    post 'sign_url_for_upload', to: 'people#sign_url_for_upload'

    # GET routes
    get 'total_people', to: 'people#total_people'
    get 'total_groups', to: 'groups#total_groups'
    get 'get_people/:id', to: 'people#get_people_for_group'
    get 'get_groups/:id', to: 'groups#get_groups'
    get 'search_people/:query', to: 'people#search_people'
    get 'search_groups/:query', to: 'groups#search_groups'
  end
end