Myrottenpotatoes::Application.routes.draw do
  #devise_for :users
  resources :movies
  root :to => redirect('/movies')

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
end
