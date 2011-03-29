TestApp::Application.routes.draw do
  
  match '/answers/fire_object_search' => 'answers#fire_object_search'
  match '/answers/fire_populate_drop_down' => 'answers#fire_populate_drop_down'
  
  chain_template_routes = lambda do
    scope "/:context(/:question_id)" do
      resources :answers, :only => [:new, :create, :index] do
        collection do
           post :fire_populate_drop_down
           post :fire_object_search
         end
      end
    end
    scope "/:context" do
      resources :answers, :only => [:edit, :update, :show] do
        collection do
           post :fire_populate_drop_down
           post :fire_object_search
         end
      end
    end
  end

  resources :containers do
    chain_template_routes.call
  end

  root :to => "home#index"
end
