Rails.application.routes.draw do

  devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

scope module: :public do
  root to: "homes#top"
  get "about" => "homes#about", as: 'about'
  get "search" => "searches#search"
  resources :notifications, only: [:index]
  delete "destroy_all" => "notifications#destroy_all"
  resources :customers, only: [:index, :show, :edit, :update, :destroy] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'

    member do
      get :favorites
    end
  end

  resources :posts, only: [:index, :show, :edit, :new, :create, :update, :destroy] do
    resource :favorites, only: [:create, :destroy]

    resources :comments, only: [:create, :destroy]
  end
end



  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

namespace :admin do
  resources :customers, only: [:index, :show, :destroy]
  resources :posts, only: [:index, :show, :destroy]

end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
