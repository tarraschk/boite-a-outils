class Address < ActiveRecord::Base
  belongs_to :person
  cattr_accessor :skip_callbacks

  after_create  :send_to_nation_builder
  after_save    :send_to_nation_builder, unless: :skip_callbacks

  def send_to_nation_builder
    params = {primary_address: attributes.slice(*%w(address1 city zip))}

    if person.people_id
      client = NationBuilderClient.new
      client.call(:people, :update, id: person.people_id, person: params)
    end
  end

  def save_without_callbacks
    Address.skip_callbacks = true
    save
  ensure
    Address.skip_callbacks = false
  end
end
