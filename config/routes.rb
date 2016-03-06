require 'sidekiq/web'

Rails.application.routes.draw do
  resources :addresses
  resources :people do
    post    'add_tag',    on: :member
    delete  'remove_tag', on: :member
  end
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resources :gadget_files
  resources :users do
    get 'mails',    on: :member
  end

  root 'dashboards#dashboard'

  get 'dashboard', to: 'dashboards#dashboard'

  authenticate :user, lambda { |user| user.root } do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :tools do
    namespace :door_to_door_form do
      get   :committees
      post  :person
    end
    get :door_to_door_sign_up
  end

  namespace :admin_tools do
    get :dashboard
    get :people_databable
    post :send_to_nation_builder
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

end
