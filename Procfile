web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -q get_all_people_worker -q default -q get_parent_id_worker -C config/sidekiq.yml
