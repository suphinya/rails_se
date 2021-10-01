Myrottenpotatoes::Application.routes.draw do
  
  #mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  
  resources :movies do
    resources :reviews
  end

  root :to => redirect('/movies')

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
end
