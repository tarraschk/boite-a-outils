class NationBuilderSyncWorker
  include Sidekiq::Worker
  sidekiq_options queue: :get_last_people_worker

  def perform(people_id)
    logger.info "       #############                    current people id #{people_id}                 ################"
    puts        "       #############                    current people id #{people_id}                 ################"
    puts        "--- creating people id #{people_id} ---"

    person = NationBuilderClient.new.call(:people, :show, id: people_id)['person']
    puts person

    instance_person = Person.where(people_id: people_id).first_or_initialize
    instance_person.people_id     = person['id']
    instance_person.email         = person['email'].to_s
    instance_person.first_name    = person['first_name'].to_s
    instance_person.last_name     = person['last_name'].to_s
    instance_person.parent_id     = person['parent_id']
    instance_person.recruiter_id  = person['recruiter_id']
    instance_person.phone         = person['phone'].to_s
    instance_person.mobile        = person['mobile'].to_s
    instance_person.tags          = person['tags']
    instance_person.support_level = person['support_level']
    instance_person.mandat        = person['mandat']
    instance_person.save_without_callbacks

    instance_person.home_address ||= Address.new
    if home_address = person['primary_address'] || person['home_address']
      instance_person.home_address.address1 = home_address['address1']
      instance_person.home_address.address2 = home_address['address2']
      instance_person.home_address.address3 = home_address['address3']
      instance_person.home_address.city     = home_address['city']
      instance_person.home_address.zip      = home_address['zip']
      instance_person.home_address.save_without_callbacks
    end

  rescue => e
    Rails.logger.error e
    if JSON.parse(e.message)["code"] != "not_found"
      Mailer.new.send_error "NationBuilderSyncWorker("+people_id+")\n" + e.message  + "\n" + e.backtrace.inspect
    end
  end
end
