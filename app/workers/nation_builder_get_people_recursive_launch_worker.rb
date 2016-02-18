class NationBuilderGetPeopleRecursiveLaunchWorker
  include Sidekiq::Worker

  def perform
    Rails.logger.info "--- Start launching get_people_recursive worker ---"
    puts "--- Start launching get_people_recursive worker ---"

    count = NationBuilderClient.new.call(:people, :count)['people_count'] + 1000

    (0..9).each do |index|
      NationBuilderGetPeopleRecursiveWorker.perform_async(count - index)
    end

  rescue => e
    Rails.logger.error e.message
    #TODO Add mailer
  end
end

people_id = NationBuilderClient.new.call(:people, :count)['people_count'] + 1000
person = NationBuilderClient.new.call(:people, :show, id: people_id)['person']
puts person