class NationBuilderGetParentIdRecursiveWorker
  include Sidekiq::Worker
  sidekiq_options queue: :get_people_worker

  def perform(people_id)
    Rails.logger.info "--- creating parent for people id #{people_id} ---"
    puts "--- creating parent for people id #{people_id} ---"

    if people_id > 0
      person = Person.find_by(people_id: people_id)
      person.get_parent_id if person
      NationBuilderGetParentIdRecursiveWorker.perform_async(people_id - 10)
    end
  rescue => e
    logger.error e.message
    Mailer.new.send_error e.message  + "\n" + e.backtrace.inspect
  end
end
