class NationBuilderImportWorker
  include Sidekiq::Worker
  sidekiq_options queue: :get_all_people_worker

  def perform(data)
    require 'csv'
    arr_csv = CSV.read(data, :headers => :first_row)

    arr_csv.each do | row |
      puts row
      puts "--- Current person: people_id " + row["nationbuilder_id"] + " --"
      instance_person = Person.where(people_id: row["nationbuilder_id"]).first_or_initialize
      instance_person.people_id     = row["nationbuilder_id"].to_s
      instance_person.email         = row["email"].to_s
      instance_person.first_name    = row["first_name"].to_s
      instance_person.last_name     = row["last_name"].to_s
      instance_person.parent_id     = row["parent_id"].to_s
      instance_person.recruiter_id  = row["recruiter_id"].to_s
      instance_person.phone         = row["phone_number"].to_s
      instance_person.mobile        = row["mobile_number"].to_s
      instance_person.tags          = instance_person.tags.blank? ? row["tag_list"].split(", ").to_json : (JSON.parse(instance_person.tags) | row["tag_list"].split(", ")).to_json
      instance_person.support_level = row["support_level"].to_s
      instance_person.mandat        = row["mandat"].to_s
      instance_person.updated_from_nb = true
      instance_person.contacted = false | instance_person.contacted
      instance_person.save_without_callbacks

      instance_person.home_address ||= Address.new
      instance_person.home_address.address1 = row["primary_address1"].to_s
      instance_person.home_address.address2 = row["primary_address2"].to_s
      instance_person.home_address.address3 = row["primary_address3"].to_s
      instance_person.home_address.city     = row["primary_city"].to_s
      instance_person.home_address.zip      = row["primary_city"].to_s
      instance_person.home_address.save_without_callbacks
      puts instance_person.inspect
    end
  end

  def perform_from_url(url)
    puts "* Fetching " + url
    data = open(url)
    puts "Done. Starting import."
    perform(data)
  end
end
