Rails.application.routes.draw do

  devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

scope module: :public do
  root to: "homes#top"
  get "about" => "homes#about", as: 'about'
  resources :customers, only: [:index, :show, :edit, :update, :destroy] do
  end

  resources :posts, only: [:index, :show, :edit, :new, :create, :update, :destroy] do
    resource :favorites, only: [:create, :destroy]
  end
end



  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

namespace :admin do

end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
