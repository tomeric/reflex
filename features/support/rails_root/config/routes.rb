ActionController::Routing::Routes.draw do |map|
  map.root :controller => :users
  map.resources :users
  map.resources :user_sessions
  map.with_options :controller => :user_sessions do |session|
    session.login  '/login', :action => :new
    session.logout '/logout', :action => :destroy
  end
end
