class NationBuilderSyncWorker
  include Sidekiq::Worker

  def perform
    last_synchronization = Synchronization.find_or_initialize_by(event: 'people')
    updated_at = last_synchronization.updated_at

    client = NationBuilderClient.new
    params = updated_at ? [:search, updated_since: updated_at] : [:index]
    paginator = NationBuilder::Paginator.new(client, client.call(:people, *params))
    Person.skip_callbacks = true
    while paginator.next?
      create_people_from_result(paginator.body['results'])
      paginator = paginator.next
    end


  end

  def create_people_from_result(people_list)
    people_list.each do |person|
      People.create(person.slice)
    end
  end
end
