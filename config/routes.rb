Rails.application.routes.draw do
    match '*all' => 'application#cors_preflight_check', via: :options

    # Service-related resources

    resources :licenses

    resources :services do
        resources :builds do
            resources :screenshots
            resources :dependencies
            resources :exposures do
                resources :parameters
            end
            resources :configurations do
                resources :tasks
            end
        end
    end

    resources :platforms do
        resources :instances
    end

    resources :interfaces do
        resources :surrogates
    end

    # IAM-related stuff

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
