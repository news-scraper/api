# rubocop:disable Rails/Output
# rubocop:disable Rails/Exit

# Change these
server '54.85.251.80', port: 22, roles: [:web, :app, :db], primary: true

set :repo_url,        'https://github.com/news-scraper/api.git'
set :application,     'api'
set :user,            'deploy'
set :puma_threads,    [4, 16]
set :puma_workers,    0

set :migration_role, :app
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub)
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true # Change to false when not using ActiveRecord
set :linked_dirs, fetch(:linked_dirs, []).push(
  'log',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'vendor/bundle',
  'public/system',
  'public/uploads',
  'config/ssl'
)
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :chruby_ruby, 'ruby-2.3.0'

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure all linkes files exist"
  task :setup_linked_files do
    on roles(:app) do
      require 'json'
      require 'yaml'

      execute "mkdir -p #{shared_path}/config"

      # Database.yml
      puts "Parsing and uploading database.yml"
      public_key = JSON.parse(File.read('config/database.ejson'))['_public_key']
      raise "Public Key for JSON wasn't found" unless File.exist?("/opt/ejson/keys/#{public_key}")
      prod_db = JSON.parse(`ejson decrypt config/database.ejson`)
      execute "touch #{shared_path}/config/database.yml"
      Dir.mktmpdir do |dir|
        File.write("#{dir}/db.yml", prod_db.to_yaml)
        upload! "#{dir}/db.yml", "#{shared_path}/config/database.yml"
      end

      # Secrets.yml
      puts "Uploading secrets.yml to production"
      execute "touch #{shared_path}/config/secrets.yml"
      upload! "config/secrets.yml", "#{shared_path}/config/secrets.yml"
    end
  end

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      Rake::Task["puma:restart"].reenable
      invoke 'puma:restart'
    end
  end

  namespace :rake do
    desc "Run a task on a remote server."
    # run like: cap staging rake:invoke task=a_certain_task
    task :invoke do
      run("cd #{deploy_to}/current; /usr/bin/env bundle exec rake #{ENV['task']} RAILS_ENV=#{rails_env}")
    end
  end

  before :starting,                   :check_revision
  before 'check:linked_files',        'setup_linked_files'
  after :finishing,                   :cleanup
  after :finishing,                   :restart
end
