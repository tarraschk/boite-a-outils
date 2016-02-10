class NationBuilderGetAllParentIdWorker
  include Sidekiq::Worker

  def perform(people_id)
    Rails.logger.info "--- creating parent for people id #{people_id} ---"
    puts "--- creating parent for people id #{people_id} ---"

    if people_id > 0
      person = Person.find_by(people_id: people_id)
      person.get_parent_id if person
      NationBuilderGetAllParentIdWorker.perform_async(people_id-1)
    end
  end
end
