Rails.application.routes.draw do

  devise_for :users, controllers:{
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  scope module: :public do
    root to: 'homes#top'
    post '/homes/guest_sign_in', to: 'homes#guest_sign_in'
    resources :users, only:[:index, :show, :edit, :update] do
      member do
        get :favorites
      end
    end
    resources :posts do
      resource :favorites, only:[:create, :destroy]
      resources :comments, only:[:create, :destroy]
    end
    resources :groups do
      get '/post_index' => "groups#post_index" , as: "post_index"
    end
    #グループの投稿のルーティングについて
    #resources :group_posts? :posts?

  end


  devise_for :admin,　controllers: {
    registrations: "admin/registrations",
    sessions: "admin/sessions"
  }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
