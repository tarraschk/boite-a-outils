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
    #already_done = Person.where(people_id: people_list.map{|p| p['id']}).pluck(:people_id)
    #to_do = people_list.map {|person| person.slice(*%w(id email first_name last_name recruiter_id phone mobile parent_id tags support_level mandat home_address))}.map {|h| already_done.include?(h['id']) ? nil : (h['people_id'] = h.delete('id'); h)}.compact
    people_list.each do |person|
      puts        "--- creating people id #{person['id']} ---"
      ActiveRecord::Base.transaction do
        Person.skip_callbacks = true
        Person.where(people_id: person['id']).first_or_initialize do |instance_person|
          instance_person.people_id = person['id']
          instance_person.email = person['email']
          instance_person.first_name = person['first_name']
          instance_person.last_name = person['last_name']
          instance_person.recruiter_id = person['recruiter_id']
          instance_person.phone = person['phone']
          instance_person.mobile = person['mobile']
          instance_person.parent_id = person['parent_id']
          instance_person.tags = person['tags']
          instance_person.support_level = person['support_level']
          instance_person.mandat = person['mandat']
          instance_person.save

          instance_person.home_address ||= Address.new
          if home_address = person['primary_address'] || person['home_address']
            instance_person.home_address.address1 = home_address['address1']
            instance_person.home_address.address2 = home_address['address2']
            instance_person.home_address.address3 = home_address['address3']
            instance_person.home_address.city     = home_address['city']
            instance_person.home_address.zip      = home_address['zip']
            instance_person.home_address.save
          end
        end
        Person.skip_callbacks = false
      end
    end
    ActiveRecord::Base.clear_active_connections!
  end
end
