ShopifyRental3::Application.routes.draw do
  
  
  get "api/calendar/admin" => 'api#calendar_days_admin'
  post 'api/rental'         => 'api#update_rental'
  delete 'api/rental'         => 'api#delete_rental'

  match 'auth/shopify/callback' => 'login#finalize'

  match 'welcome'            => 'home#welcome'

  match 'design'             => 'home#design'

  match 'login'              => 'login#index',        :as => :login

  match 'login/authenticate' => 'login#authenticate', :as => :authenticate

  match 'login/finalize'     => 'login#finalize',     :as => :finalize

  match 'login/logout'       => 'login#logout',       :as => :logout
  
  post 'webhooks/orders/create' => 'webhook#order_created'
  post 'webhooks/orders/cancelled' => 'webhook#order_cancelled'
  
  post 'webhooks/products/create'  => 'webhook#product_created'
  get "webhooks/rental_json"       => 'webhook#rentals_json'
  
  post '/admin/addRentals'         => 'admin#add_rentals_ajax'
  match 'admin/rentals'   => 'admin#admin_rentals'   
  get 'admin/add_rental/:layout'   => 'admin#add_rental'
  post 'admin/findProducts'       => 'admin#getAvailabilityAll'
 # get 'modal/rental'  => 'modal#rental'

  match '/admin/:action', :controller => 'admin'
  get 'modal/:action', :controller => 'modal'
  
  match 'webhooks/test' => 'webhook#test'
  match '/chargify/hooks' => "chargify#dispatch_handler", :via => "post"
 

  root :to                   => 'home#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
