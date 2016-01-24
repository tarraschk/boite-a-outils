class NationBuilderSyncWorker
  include Sidekiq::Worker

  def perform
    last_synchronization = Synchronization.find_or_initialize_by(event: 'people')
    updated_at = last_synchronization.updated_at
    last_synchronization.updated_at = Time.now

    client = NationBuilderClient.new
    params = updated_at ? [:search, updated_since: updated_at, limit: 100] : [:index, limit: 100]
    paginator = NationBuilder::Paginator.new(client, client.call(:people, *params))
    Person.skip_callbacks = true
    while paginator.next? #&& Person.count < 200
      create_people_from_result(paginator.body['results'])
      begin
        paginator = paginator.next
      rescue => e
        Rails.logger.error e
        retry
      end
    end

    ActiveRecord::Base.record_timestamps = false
    last_synchronization.save
    ActiveRecord::Base.record_timestamps = true
    Person.skip_callbacks = false

    NationBuilderSyncWorker.perform_async

  end

  def create_people_from_result(people_list)
    logger.info "       #############                    current people id #{people_list.first['id']}                 ################"
    puts        "       #############                    current people id #{people_list.first['id']}                 ################"
    already_done = Person.where(people_id: people_list.map{|p| p['id']}).pluck(:people_id)
    to_do = people_list.map {|person| person.slice(*%w(id email first_name last_name recruiter_id phone_number parent_id))}.map {|h| already_done.include?(h['id']) ? nil : (h['people_id'] = h.delete('id'); h)}.compact
    ActiveRecord::Base.transaction do
      Person.create(to_do)
    end
    ActiveRecord::Base.clear_active_connections!
  end
end
