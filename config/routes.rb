Rails.application.routes.draw do

  resources :pending_players
  get 'static_pages/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'network#index'

  get "/local" => "network#local"
  get "/online" => "network#online"
  get "/computer" => "network#computer"

  get 'board' => 'board#show'
  post "/network/update" => "network#update"

  get "tutorial/teams" => "tutorial#teams"
  get "tutorial/board" => "tutorial#board"

  match "/placeChip" => "network#placeChip", :via => :post
  match "/getNetworks" => "network#getNetworks", :via => :post
  match "/player/create" => "network#createPlayer", :via => :post
  match "/pending_player/request_game" => "pending_players#request_game", :via => :post
  match "/pending_player/update" => "pending_players#update", :via => :post
  match "/pending_player/active" => "pending_players#active", :via => :get

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
