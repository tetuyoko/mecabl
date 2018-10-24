Rails.application.routes.draw do
  root to: 'home#index'

  # routeに設定いれて rails g administrate:install
  namespace :admin do
    resources :crawl_statuses
    resources :entries
    resources :feeds
    resources :train_histories
    resources :train_masters
    root to: "crawl_statuses#index"
  end

  namespace :debug do
    resources :classifier do 
      collection do
        get :train
      end
      member do
        post :do
      end
    end
  end

  resources :crawl_statuses, except: [:new, :edit]
  resources :feeds, except: [:new, :edit]
  resources :entries, except: [:new, :edit]  do
    member do
      post :train
    end
  end
  
  get :new_image, to: 'entries#new_image'
end
