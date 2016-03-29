class Person < ActiveRecord::Base
  cattr_accessor :skip_callbacks

  cattr_accessor :skip_get_parent_id_callbacks

  belongs_to :parent,     class_name: Person, primary_key: :people_id
  belongs_to :recruiter,  class_name: Person, primary_key: :people_id
  belongs_to :user

  has_many :children,     class_name: Person, primary_key: :people_id, foreign_key: :parent_id
  has_many :recruitees,   class_name: Person, primary_key: :people_id, foreign_key: :recruiter_id

  has_one :home_address, class_name: Address, foreign_key: :person_id

  scope :activated, -> { where(activated: true) }
  scope :desactivated, -> { where(activated: false) }

  accepts_nested_attributes_for :home_address

  validates :people_id, uniqueness: true, unless: :skip_callbacks

  #after_create  :get_parent_id, unless: skip_callbacks

  #after_save    :send_to_nation_builder,  unless: :skip_callbacks
  #after_save    :get_parent_id,           unless: :skip_get_parent_id_callbacks

  def before_create
    self.created_at = Time.now
    self.updated_at = Time.now
  end

  def save_without_callbacks
    Person.skip_callbacks               = true
    Person.skip_get_parent_id_callbacks = true
    save
  ensure
    Person.skip_callbacks               = false
    Person.skip_get_parent_id_callbacks = false
  end

  def update_without_callbacks(person_params)
    Person.skip_callbacks               = true
    Person.skip_get_parent_id_callbacks = true
    update(person_params)
  ensure
    Person.skip_callbacks               = false
    Person.skip_get_parent_id_callbacks = false
  end

  def send_to_nation_builder(send_to_nb = false)
    return unless people_id || send_to_nb
    return unless email || mobile || phone

    if changed.map(&:to_s).include?('contacted')
      puts "TODO do synchro robot"
    end

    client = NationBuilderClient.new

    unless (changed.map(&:to_s) & %w(email first_name last_name parent_id phone mobile tags)).empty?
      params = attributes.slice(*%w(email first_name last_name parent_id phone mobile))
      params.keys.each do |key|
        params[key] = '' if params[key].nil?
      end

      if people_id
        client.call(:people, :update, id: people_id, person: params)
        if changed.include?('tags')
          old_tags = JSON.parse(changes['tags'][0] || '[]')
          new_tags = JSON.parse(changes['tags'][1] || '[]')

          tags_to_remove  = old_tags - new_tags
          tags_to_add     = new_tags - old_tags

          tags_to_remove.each do |tag|
            client.call(:people, :tag_removal, id: people_id, tag: tag)
          end
          tags_to_add.each do |tag|
            client.call(:people, :tag_person, id: people_id, tagging: tag)
          end
        end
      else
        new_tags = JSON.parse(changes['tags'][1])
        r = client.call(:people, :create, person: params)

        Person.skip_callbacks = true
        update(people_id: r['person']['id'])
        Person.skip_callbacks = false

        new_tags.each do |tag|
          client.call(:people, :tag_person, id: r['person']['id'], tagging: {tag: tag})
        end

      end
    end

  end

  def get_parent_id
    if people_id
      #NationBuilderGetParentIdWorker.perform_async(people_id)
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def activate
    update_without_callbacks(activated: true)
  end

  def desactivate
    update_without_callbacks(activated: false)
  end

end
