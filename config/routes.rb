Rails.application.routes.draw do

  #root to: 'homes#top'

  devise_for :users, controllers:{
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }



  devise_for :admin,　controllers: {
    registrations: "admin/registrations",
    sessions: "admin/sessions"
  }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
