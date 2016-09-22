Rails.application.routes.draw do
  mount LetsencryptPlugin::Engine, at: '/'

  root 'training_logs#index'

  resources :scrape_queries, except: [:update, :edit, :new]
  resources :domains, except: [:edit, :new]

  controller :news_articles do
    get 'news_articles' => :index, as: :news_articles
    get 'news_articles/:query' => :articles, as: :news_articles_by_query
  end

  controller :training_logs do
    get 'training_logs' => :index, as: :training_logs
    get 'training_logs/by_domain' => :by_root_domain, as: :training_log_by_domain
    get 'training_logs/:id' => :show, as: :training_log
    post 'training_logs' => :create, as: :create_training_log

    post 'training_logs/claim' => :claim, as: :claim_training_logs
    post 'training_logs/unclaim' => :unclaim, as: :unclaim_training_logs
    post 'training_logs/train' => :train, as: :train_training_logs
  end
end
