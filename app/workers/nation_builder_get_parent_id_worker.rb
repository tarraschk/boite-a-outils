class NationBuilderGetParentIdWorker
  include Sidekiq::Worker
  sidekiq_options queue: :get_parent_id_worker

  def perform(people_id)
    Rails.logger.info "--- creating parent for people id #{people_id} ---"
    puts "--- creating parent for people id #{people_id} ---"

    person = Person.find_by(people_id: people_id)
    return unless person
    client = NationBuilderClient.new
    parent_id = client.call(:people, :show, id: people_id)['person'].slice('parent_id')

    unless parent_id['parent_id'].blank?
      person.parent_id        = parent_id['parent_id']
      person.updated_from_nb  = true
      person.save_without_callbacks
    end
  end
end
