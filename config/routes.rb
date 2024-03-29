Rails.application.routes.draw do
  root :to => 'home#index'

  namespace :v1 do

    # Resources
    resources :churches
    resources :users
    resources :person_profiles
    resources :people
    resources :groups
    resources :event_exceptions
    resources :event_schemas

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
    post 'people_bulk_import', to: 'people#bulk_import'
    post 'group_send_mail', to: 'groups#send_mail'
    post 'group_send_sms', to: 'groups#send_sms'
    post 'group_bulk_export', to: 'groups#bulk_export'
    post 'add_event_to_groups', to: 'event_schemas#add_event_to_groups'
    post 'confirm_email', to: 'users#confirm_email'
    post 'forgot_password', to: 'users#forgot_password'
    post 'reset_password', to: 'users#reset_password'
    post 'app_feedback', to: 'people#app_feedback'
    post 'update_person_details', to: 'people#update_person_details'

    # GET routes
    get 'total_people', to: 'people#total_people'
    get 'total_groups', to: 'groups#total_groups'
    get 'get_people/:id', to: 'people#get_people_for_group'
    get 'get_groups/:id', to: 'groups#get_groups'
    get 'search_people/:query', to: 'people#search_people'
    get 'search_groups/:query', to: 'groups#search_groups'
    get 'filter_search_people/:query', to: 'people#filter_search_people'
    get 'upcoming_events', to: 'event_schemas#upcoming_events'
    get 'get_events_for_group/:group_id', to: 'event_schemas#get_events_for_group'
    get 'get_church_info/:church_id', to: 'churches#church_info'
    get 'get_local_churches/:church_id', to: 'churches#local_churches'
    get 'get_person_details/:person_id', to: 'people#get_person_details'
    # get 'test', to: 'users#test'

    # DELETE routes
    delete 'delete_local_church/:church_id', to: 'churches#delete_local_church'

    # Updates
    get 'get_people_updates', to: 'people#get_updates'
    get 'get_groups_updates', to: 'groups#get_updates'
    get 'get_events_updates', to: 'event_schemas#get_updates'

    # Statistics
    get 'get_people_stats', to: 'people#get_people_stats'
    get 'get_events_density_stats', to: 'event_schemas#get_events_density_stats'
    get 'get_actions_stats', to: 'users#get_actions_stats'
  end
end
