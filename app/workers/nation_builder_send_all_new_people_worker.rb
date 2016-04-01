class NationBuilderSendAllNewPeopleWorker
  include Sidekiq::Worker

  def perform
    Person.where(people_id: nil).each do |person|
      person.send_to_nation_builder(true)
    end
  end
end
