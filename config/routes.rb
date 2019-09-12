Rails.application.routes.draw do


  resources :badges
  resources :attempts
    # match '*all' => 'application#cors_preflight_check', via: :options

    # Serve websocket cable requests in-process
    # mount ActionCable.server => '/websocket/:platform_id'
    mount ActionCable.server => '/websocket'

    # Product-related resources

    resources :vouchers
    resources :licenses

    resources :attempts,	only: [:index, :show]
    resources :entitlements do
		member do
    		get :claims
		end
    end

    resources :products do
        resources :licenses, controller: :product_licenses
        member do
            post :publish
            post :unpublish
            get :children
            get :parents
            get 'logo/large' => 'products#large', as: :large_logo
            get 'logo/medium' => 'products#medium', as: :medium_logo
            get 'logo/small' => 'products#small', as: :small_logo
        end
        resources :screenshots do
            member do
                get :large
                get :medium
                get :small
            end
        end
        collection do
            post :search, as: :search_services
        end
        resources :builds do
            member do
                get :asset
                resources :dependencies
                resources :exposures do
                    member do
                        resources :parameters
                    end
                end
                resources :configurations do
                    member do
                        resources :tasks
                    end
                end
            end
        end
    end
    resources :sub_products

    resources :interfaces do
        member do
            resources :surrogates
        end
    end

    # IAM-related stuff

    resources :users do
        resources :identities
        resources :platforms do
            resources :instances
        end
    end

    resources :groups do
        resources :members
    end

    resources :roles do
        resources :appointments
    end
    
    resources :identity_providers do
        member do
            get		:redirect
            post	:enable
            post	:disable
        end
    end

    put 'authorizations/users/:user_id/products/:product_id' => 'authorizations#user_product',	as: :authorize_user_product
	put 'authorizations/groups/:group_id/products/:product_id' => 'authorizations#group_product',	as: :authorize_group_product
	put 'authorizations/products/:product_id' => 'authorizations#requester_role_product',	as: :authorize_requester_role_product


    get		'sessions' => 'sessions#callback',		as: :callback
    # post	'sessions' => 'sessions#authenticate',	as: :login
    delete	'sessions' => 'sessions#destroy',		as: :logout
    get 'dashboard' => 'welcome#dashboard',			as: :dashboard
    get 'status' => 'welcome#status',				as: :status

    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".

    # You can have the root of your site routed with "root"
    root 'sessions#callback'
end
