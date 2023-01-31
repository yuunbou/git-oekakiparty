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
    
    #ユーザー
    resources :users, only:[:index, :show, :edit, :update] do
      #get "/users/confirm" => "users#confirm", as: "confirm"
      #patch "/users/withdraw" => "users#withdraw", as: "withdraw"
      member do
        get :favorites
        get :posts
        get :groups
        get :confirm
        patch :withdraw
      end
    end
    #投稿
    resources :posts do
      collection do
        get '/search_index' => "posts#search_index", as: "search_index"
      end

      resource :favorites, only:[:create, :destroy]
      resources :comments, only:[:create, :destroy]
    end
    #グループ
    resources :groups do
      get '/post_index' => "groups#post_index" , as: "post_index"
      #join = 加入
      get '/join' => "groups#join", as: "join"
      #グループのユーザーリスト
      get '/join_group' => "groups#join_group", as: "join_group"
      #グループのメンバーの追加
      post '/join_user' => "groups#join_user", as: "join_user"
      #グループのメンバーの削除
      delete '/join_destroy' => "groups#join_destroy", as: "join_destroy"
      #グループの削除
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
    #投稿
    resources :posts, only:[:index, :show, :destroy, :edit, :update] do
      resources :comments, only:[:destroy]
    end
    #コメント一覧
    resources :comments, only:[:index]
    #グループ
    resources :groups, only:[:index, :show] do
      get '/post_index' => "groups#post_index" , as: "post_index"
      delete "all_destroy" => 'groups#all_destroy'
    end
    
    
  end
  
  
  

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
