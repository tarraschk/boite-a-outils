class NationBuilderGetParentIdWorker
  include Sidekiq::Worker

  def perform(people_id)
    Rails.logger.info "--- creating parent for people id #{people_id} ---"

    person = Person.find_by(people_id: people_id)
    return unless person
    client = NationBuilderClient.new
    parent_id = client.call(:people, :show, id: people_id)['person'].slice('parent_id').merge(updated_from_nb: true)

    Person.skip_get_parent_id_callbacks = true
    Person.skip_callbacks               = true
    person.update(parent_id) unless parent_id['parent_id'].blank?
  ensure
    Person.skip_get_parent_id_callbacks = false
    Person.skip_callbacks               = false
  end
end
