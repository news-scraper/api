require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  mount LetsencryptPlugin::Engine, at: '/'
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
    mount Blazer::Engine, at: "blazer"
  end

  root 'dashboard#index'

  resources :scrape_queries, except: [:update, :edit, :new]
  resources :domains, except: [:edit, :new]

  controller :dashboard do
    get 'dashboard' => :index, as: :dashboard
    get 'database' => :database
  end

  controller :users do
    get 'users/profile' => :profile, as: :profile
    put 'users/profile' => :update, as: :update_profile
  end

  controller :news_articles do
    get 'news_articles' => :index, as: :news_articles
    get 'news_articles/:query' => :articles, as: :news_articles_by_query
  end

  controller :training_logs do
    get 'training_logs' => :index, as: :training_logs
    get 'training_logs/by_domain' => :by_root_domain, as: :training_log_by_domain
    get 'training_logs/:id' => :show, as: :training_log
    post 'training_logs' => :create, as: :create_training_log
  end

  controller :training_flow do
    post 'training/log/:id/claim'       => :claim,          as: :claim_training_logs
    post 'training/log/:id/unclaim'     => :unclaim,        as: :unclaim_training_logs
    post 'training/log/:id/untrainable' => :untrainable,    as: :untrainable_training_logs
    post 'training/log/:id/train'       => :train,          as: :train_training_logs
    get  'training/log/:id/train'       => :train_domain,   as: :train_domain
  end
end
