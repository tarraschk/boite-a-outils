class Person < ActiveRecord::Base

  cattr_accessor :skip_callbacks

  belongs_to :parent,     class_name: Person, primary_key: :people_id
  belongs_to :recruiter,  class_name: Person, primary_key: :people_id
  belongs_to :user

  has_many :children,     class_name: Person, primary_key: :people_id, foreign_key: :parent_id
  has_many :recruitees,   class_name: Person, primary_key: :people_id, foreign_key: :recruiter_id

  after_create  :send_to_nation_builder, unless: :skip_callbacks
  after_save    :send_to_nation_builder, unless: :skip_callbacks

  def send_to_nation_builder
    client = NationBuilderClient.new

    params = {
        person: attributes.slice(*%w(email first_name last_name phone_number))
    }
    if people_id
      #client.call(:person, :update, id: people_id, params)
    else
      #client.call(:person, :create, params)
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end


end
