ActionController::Routing::Routes.draw do |map|
  map.resources :users

  map.resource :session

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  
  map.resources :feed
  map.resources :feed_comment
  map.connect 'feed_item/media', :controller => 'feed_item', :action => 'media'
  map.resources :feed_item
  map.resources :feed_item_category
  map.resources :category
  map.resources :category_comment
  map.resources :homepage
  map.resources :feed_item_comment
  map.resources :category_organizer
  map.resources :comment
  map.resources :blog_posts
  map.resources :email_subscriptions
  map.connect 'blog', :controller => 'blog_posts'
  
  map.connect 'privacy-policy', :controller => 'static_pages', :action => 'privacy_policy'
  map.connect 'sitemap',        :controller => 'static_pages', :action => 'sitemap'
  map.connect 'contact-us',     :controller => 'static_pages', :action => 'contact_us'
  map.connect 'advertise',      :controller => 'static_pages', :action => 'advertise'
  map.connect 'contribute',     :controller => 'static_pages', :action => 'contribute'
  map.connect 'how-it-works',   :controller => 'static_pages', :action => 'how_it_works'
  map.connect 'search',         :controller => 'static_pages', :action => 'search'
  map.connect 'open-source',    :controller => 'static_pages', :action => 'open_source'
  
  map.connect 'sitemap.xml', :controller => 'sitemap', :action => 'index'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  map.homepage '', :controller => 'homepage'
  
  map.connect 'update', :controller => 'feed', :action => 'update'
  
  map.root :controller => "homepage"
  
  map.connect '*', :controller => 'application', :action => 'rescue_404' 
end
