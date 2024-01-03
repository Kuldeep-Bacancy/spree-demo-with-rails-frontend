Rails.application.routes.draw do
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to
  # Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the
  # :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being
  # the default of "spree".
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  mount Spree::Core::Engine, at: '/'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  Spree::Core::Engine.add_routes do
    namespace :admin do
      post :import_products
      get :export_products, constraints: { format: 'csv' }
    end
  end

  Spree::Core::Engine.routes.draw do
    get "/admin/products/upload", to: "admin/products#upload"
    get "/admin/products/upload_status", to: "admin/products#upload_status"
    post "/admin/products/process_upload", to: "admin/products#process_upload"
  end
end
