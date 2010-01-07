ActionController::Routing::Routes.draw do |map|
  map.resources :passwords,
    :controller => 'clearance/passwords',
    :only       => [:new, :create]

  map.resource  :session,
    :controller => 'clearance/sessions',
    :only       => [:new, :create, :destroy]

  map.resources :users, :controller => 'clearance/users' do |users|
    users.resource :password,
      :controller => 'clearance/passwords',
      :only       => [:create, :edit, :update]

    users.resource :confirmation,
      :controller => 'clearance/confirmations',
      :only       => [:new, :create]
  end

  map.sign_up  'sign_up',
    :controller => 'clearance/users',
    :action     => 'new'
  map.sign_in  'sign_in',
    :controller => 'clearance/sessions',
    :action     => 'new'
  map.sign_out 'sign_out',
    :controller => 'clearance/sessions',
    :action     => 'destroy',
    :method     => :delete
    
  #invitations
  map.resources :invites, :controller => 'clearance/invites'
    
  map.send_invitation '/send_invitation/:id', :controller => "clearance/invites", :action => "send_invitation"
  map.redeem_invitation '/sign_up/:invite_code', :controller => 'clearance/users', :action => 'new'      
        
end
