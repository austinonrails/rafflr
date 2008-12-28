ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  
  map.home '', :controller => 'raffles', :action => 'index'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.new_raffle 'new', :controller => 'raffles', :action => 'new'
  map.raffle 'raffles/:id', :controller => 'raffles', :action => 'show', :id => /\d+/
  
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'

end
