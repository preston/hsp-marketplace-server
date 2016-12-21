Rails.application.routes.draw do
    match '*all' => 'application#cors_preflight_check', via: :options

    resources :users do
        resources :identities
    end

    resources :groups do
        resources :members
    end

    resources :roles do
        resources :appointments
    end

    resources :clients do
        member do
            get 'launch'
        end
    end
    resources :identity_providers

    get		'sessions' => 'sessions#callback',	as: :callback
    post	'sessions' => 'sessions#authenticate',	as: :login
    delete	'sessions' => 'sessions#destroy',	as: :logout
    get 'dashboard' => 'welcome#dashboard', as: :dashboard
    get 'status' => 'welcome#status', as: :status

    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".

    namespace :smart do
        get 'launch' => 'launch#launch'
    end
    # You can have the root of your site routed with "root"
    root 'welcome#landing'
end
