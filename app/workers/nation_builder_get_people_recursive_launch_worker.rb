class NationBuilderGetPeopleRecursiveLaunchWorker
  include Sidekiq::Worker

  def perform
    Rails.logger.info "--- Start launching get_parent_id_recursive worker ---"

    count = NationBuilderClient.new.call(:people, :count)['people_count'] + 1000

    (0..9).each do |index|
      NationBuilderGetPeopleRecursiveWorker.perform_async(count - index)
    end

  rescue => e
    Rails.logger.error e.message
    #TODO Add mailer
  end
end
