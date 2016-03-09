class NationBuilderGetPeopleRecursiveWorker
  include Sidekiq::Worker
  sidekiq_options queue: :get_all_people_worker

  def perform(people_id)
    Rails.logger.info "--- creating people for people id #{people_id} ---"
    puts "--- creating people for people id #{people_id} ---"

    if people_id > 0
      person = NationBuilderClient.new.call(:people, :show, id: people_id)['person']
      puts person

      instance_person = Person.where(people_id: person['id']).first_or_initialize
      instance_person.people_id     = person['id']
      instance_person.parent_id     = person['parent_id']
      instance_person.email         = person['email'].to_s
      instance_person.first_name    = person['first_name'].to_s
      instance_person.last_name     = person['last_name'].to_s
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
    end
  rescue => e
    Rails.logger.error e
    if JSON.parse(e.message)["code"] != "not_found"
      Mailer.new.send_error "NationBuilderGetPeopleRecursiveWorker("+people_id.to_s+")\n" + e.message  + "\n" + e.backtrace.inspect
    end
  ensure
    if people_id > 50
      NationBuilderGetPeopleRecursiveWorker.perform_async(people_id - 50)
    elsif people_id == 50
      NationBuilderGetPeopleRecursiveLaunchWorker.perform_async
    end
  end
end
