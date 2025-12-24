Rails.application.routes.draw do
  devise_for :users
  
  # Mockups namespace for design mockups
  namespace :mockups do
    get "/", to: "pages#index", as: :root
    
    # Auth pages
    get "login", to: "pages#login"
    get "signup", to: "pages#signup"
    
    # Admin pages
    get "admin/dashboard", to: "pages#admin_dashboard"
    get "admin/devices", to: "pages#admin_devices"
    get "admin/devices/:id", to: "pages#admin_device_detail", as: :admin_device_detail
    get "admin/team", to: "pages#admin_team"
    get "admin/billing", to: "pages#admin_billing"
    get "admin/treatments", to: "pages#admin_treatments"
    
    # Operator pages
    get "operator/dashboard", to: "pages#operator_dashboard"
    get "operator/monitor", to: "pages#operator_monitor"
    get "operator/new_treatment", to: "pages#operator_new_treatment"
    get "operator/treatments", to: "pages#operator_treatments"
    get "operator/treatments/:id", to: "pages#operator_treatment_detail", as: :operator_treatment_detail
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "mockups/pages#index"
end
