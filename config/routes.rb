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

    # Custom routes
    
    # POST routes
    post 'authentication', to: 'authentication#create'
    post 'get_user_info', to: 'users#get_user_info'
    post 'add_person_to_group', to: 'people#add_person_to_group'
    post 'add_people_to_groups', to: 'people#add_people_to_groups'
    post 'remove_person_groups', to: 'people#remove_person_groups'
    post 'sign_url_for_upload', to: 'people#sign_url_for_upload'
    post 'send_sms', to: 'people#send_sms'
    post 'send_mail', to: 'people#send_mail'
    post 'people_bulk_delete', to: 'people#bulk_delete'
    post 'people_bulk_export', to: 'people#bulk_export'
    post 'get_people_with_filter', to: 'people#get_people_with_filter'

    # GET routes
    get 'total_people', to: 'people#total_people'
    get 'total_groups', to: 'groups#total_groups'
    get 'get_people/:id', to: 'people#get_people_for_group'
    get 'get_groups/:id', to: 'groups#get_groups'
    get 'search_people/:query', to: 'people#search_people'
    get 'search_groups/:query', to: 'groups#search_groups'
    get 'filter_search_people/:query', to: 'people#filter_search_people'
  end
end