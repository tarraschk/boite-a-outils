class NationBuilderGetParentIdWorker
  include Sidekiq::Worker

  def perform(people_id)
    client = NationBuilderClient.new
    parent_id = client.call(:people, :show, id: people_id)['person'].slice('parent_id').merge(updated_from_nb: true)

    Person.find_by(people_id: people_id).update(parent_id) unless parent_id['parent_id'].blank?
  end
end
