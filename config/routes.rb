Cats99::Application.routes.draw do
  root to: "cats#index"

  resources :users
  resource :session
  resources :cats
  resources :cat_rental_requests do
      patch "approve", on: :member
      patch "deny", on: :member
  end
end
