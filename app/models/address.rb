class Address < ActiveRecord::Base
  belongs_to :person

  after_create  :send_to_nation_builder
  after_save    :send_to_nation_builder

  def send_to_nation_builder
    params = {primary_address: attributes.slice(*%w(address1 city zip))}

    if person.people_id
      client = NationBuilderClient.new
      client.call(:people, :update, id: person.people_id, person: params)
    end
  end
end
