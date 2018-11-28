Rails.application.routes.draw do
  resources :person_profiles
  resources :people
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
  
  end
end
