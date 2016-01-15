class Person < ActiveRecord::Base

  cattr_accessor :skip_callbacks

  belongs_to :parent,     class_name: Person, primary_key: :people_id
  belongs_to :recruiter,  class_name: Person, primary_key: :people_id
  belongs_to :user

  has_many :children,     class_name: Person, primary_key: :people_id, foreign_key: :parent_id
  has_many :recruitees,   class_name: Person, primary_key: :people_id, foreign_key: :recruiter_id

  validates :people_id, uniqueness: true, unless: :skip_callbacks

  after_create  :send_to_nation_builder, unless: :skip_callbacks

  after_create  :get_parent_id

  after_save    :send_to_nation_builder, unless: :skip_callbacks

  def send_to_nation_builder

    if changed.map(&:to_s).include?('contacted')
      puts "TODO do synchro robot"
    end

    unless (changed.map(&:to_s) & %w(email first_name last_name)).empty?
      client = NationBuilderClient.new
      params = attributes.slice(*%w(email first_name last_name))

      if people_id
        client.call(:people, :update, id: people_id, person: params)
      else
        r = client.call(:people, :create, person: params)
        Person.skip_callbacks = true
        update(people_id: r['person']['id'])
        Person.skip_callbacks = false
      end
    end
  end

  def get_parent_id
    if people_id
      NationBuilderGetParentIdWorker.perform_async(people_id)
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end


end
