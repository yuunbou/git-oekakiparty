Rails.application.routes.draw do

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
    #post '/homes/guest_sign_in', to: 'homes#guest_sign_in'

    resources :users, only:[:index, :show, :edit, :update] do
      member do
        get :favorites
        get :posts
        get :groups
      end
    end
    resources :posts, only:[:show, :new, :create, :edit, :update] do
      collection do
        get '/search_index' => "posts#search_index", as: "search_index"
      end

      resource :favorites, only:[:create, :destroy]
      resources :comments, only:[:create, :destroy]
    end
    #resources :group_users, only:[:create, :destroy]
    resources :groups do
      get '/post_index' => "groups#post_index" , as: "post_index"
      get '/join' => "groups#join", as: "join"
      #join = 加入
      #get '/user_list' => "groups#user_lists", as: "user_list"
    end

  end


  devise_for :admin,　controllers: {
    registrations: "admin/registrations",
    sessions: "admin/sessions"
  }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
