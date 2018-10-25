Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :recipes
      resources :users do
        collection do
          post 'confirm'
          post 'login'
          post 'find_user'
        end
        member do
          get :get_following, :get_followers, :get_user_recipes, :is_following
          post :follow_user
          delete :unfollow_user
        end
      end
      post 'user_token' => 'user_token#create'
    end
  end
end
