release: ./bin/rails db:migrate
web: ./bin/rails server
worker: bundle exec sidekiq -t 25 -c 2
