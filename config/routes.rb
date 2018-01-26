SociaLoginRails::Application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  get "pages/terms"
  get "pages/welcome"
  get "pages/landing"

  resources :users do
    resources :widgets do
      collection {post :sort}
    end

  end

  root :to => 'pages#landing'
end
