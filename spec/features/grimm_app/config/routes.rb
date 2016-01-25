GrimmApplication.route.draw do
  root "lists#index"
  resources :lists
end
