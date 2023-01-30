Rails.application.routes.draw do


  #会員側
  devise_for :users, controllers:{
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  #ゲストログイン
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  scope module: :public do
    root to: 'homes#top'
    get "/about" => "homes#about", as: "about"
    
    resources :users, only:[:index, :show, :edit, :update] do
      get "/users/confirm" => "users#confirm"
      patch "/users/withdraw" => "users#withdraw", as: "withdraw"
      member do
        get :favorites
        get :posts
        get :groups
      end
    end
    resources :posts do
      collection do
        get '/search_index' => "posts#search_index", as: "search_index"
      end

      resource :favorites, only:[:create, :destroy]
      resources :comments, only:[:create, :destroy]
    end
    resources :groups do
      get '/post_index' => "groups#post_index" , as: "post_index"
      #join = 加入
      get '/join' => "groups#join", as: "join"
      get '/join_group' => "groups#join_group", as: "join_group"
      post '/join_user' => "groups#join_user", as: "join_user"
      # 新たにグループを抜けるアクションを作らなくてはならない
      delete '/join_destroy' => "groups#join_destroy", as: "join_destroy"
      delete "all_destroy" => 'groups#all_destroy'
    end

  end

 #管理者側
  devise_for :admin, controllers: {
    registrations: "admin/registrations",
    sessions: "admin/sessions"
  }
  
  namespace :admin do
    resources :users, only:[:index, :show, :edit, :update] do
      member do
        get :posts
        get :groups
      end
    end
    
    resources :posts, only:[:index, :show, :destroy] do
      resources :comments, only:[:destroy]
    end
    resources :comments, only:[:index]
    resources :groups, only:[:index, :show] do
      get '/post_index' => "groups#post_index" , as: "post_index"
    end
    
    
  end
  
  
  

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
