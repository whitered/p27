P27::Application.routes.draw do

  root :to => 'home#index'

  devise_for :users, :skip => [:sessions, :registrations], :controllers => {:registrations => 'registrations'} do
    get '/login' => 'devise/sessions#new', :as => :new_user_session
    post '/login' => 'devise/sessions#create', :as => :user_session
    get '/logout' => 'devise/sessions#destroy', :as => :destroy_user_session

    get '/registration' => 'registrations#new', :as => :new_user_registration
    post '/registration' => 'registrations#create', :as => :user_registration
    get '/profile' => 'registrations#edit', :as => :edit_user_registration
    put '/registration' => 'registrations#update', :as => nil
  end

  get '/my_groups' => 'groups#my_groups', :as => :my_groups

  resources :groups, :only => [:new, :create, :show, :index, :edit, :update] do
    resources :invitations, :only => [:new, :create]
    resources :posts, :only => [:new, :create]
    resources :games, :only => [:new, :create, :index]
    resources :memberships, :only => [:create]
    get :archive, :controller => :games
  end

  resources :users, :only => [:show]

  resources :invitations, :only => [:index] do
    member do
      post :accept
      post :decline
    end
  end

  resources :posts, :only => [:show, :edit, :update, :index] do
    resources :comments, :only => [:create]
  end

  resources :games, :only => [:show, :edit, :update, :index] do
    member do
      post :join
      post :leave
    end
  end

  resources :memberships, :only => [:destroy, :update]

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
