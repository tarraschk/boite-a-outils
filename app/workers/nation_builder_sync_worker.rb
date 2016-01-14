class NationBuilderSyncWorker
  include Sidekiq::Worker

  def perform
    last_synchronization = Synchronization.find_or_initialize_by(event: 'people')
    updated_at = last_synchronization.updated_at

    client = NationBuilderClient.new
    params = updated_at ? [:search, updated_since: updated_at, limit: 100] : [:index, limit: 100]
    paginator = NationBuilder::Paginator.new(client, client.call(:people, *params))
    Person.skip_callbacks = true
    while paginator.next? #&& Person.count < 200
      create_people_from_result(paginator.body['results'])
      paginator = paginator.next
    end

    last_synchronization.save
    Person.skip_callbacks = false

  end

  def create_people_from_result(people_list)
    already_done = Person.where(people_id: people_list.map{|p| p['id']}).pluck(:people_id)
    to_do = people_list.map {|person| person.slice(*%w(id email first_name last_name recruiter_id phone_number parent_id))}.map {|h| already_done.include?(h['id']) ? nil : (h['people_id'] = h.delete('id'); h)}.compact
    ActiveRecord::Base.transaction do
      Person.create(to_do)
    end
    ActiveRecord::Base.clear_active_connections!
  end
end
