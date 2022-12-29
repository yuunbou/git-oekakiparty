Rails.application.routes.draw do

  devise_for :users, controllers:{
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  scope module: :public do
    root to: 'homes#top'
    post '/homes/guest_sign_in', to: 'homes#guest_sign_in'
    resources :users, only:[:index, :show, :edit, :update]
    resources :posts, only:[:new, :create, :show, :edit, :update, :destroy, :index] do
      resource :favorites, only: [:create, :destroy]
    end
    #get "/users/:id/posts" => "posts#post_index"
  end


  devise_for :admin,　controllers: {
    registrations: "admin/registrations",
    sessions: "admin/sessions"
  }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
