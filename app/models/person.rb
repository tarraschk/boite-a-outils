class Person < ActiveRecord::Base
  attr_accessor :user_connected
  cattr_accessor :skip_callbacks

  cattr_accessor :skip_get_parent_id_callbacks

  belongs_to :parent,     class_name: Person, primary_key: :people_id
  belongs_to :recruiter,  class_name: Person, primary_key: :people_id

  has_many :user_to_person_relations
  has_many :users, through: :user_to_person_relations

  has_many :children,     class_name: Person, primary_key: :people_id, foreign_key: :parent_id
  has_many :recruitees,   class_name: Person, primary_key: :people_id, foreign_key: :recruiter_id

  has_one :home_address, class_name: Address, foreign_key: :person_id

  scope :activated, -> { where(activated: true) }
  scope :desactivated, -> { where(activated: false) }

  scope :animators_for_department, ->(department) {
    where('tags LIKE ?', '%comite_animateur\"%').
        activated.order('(contacted is null or contacted = false) DESC, last_name ASC').joins(:home_address).
        merge(Address.where('zip LIKE ?', "#{department}%"))
  }

  scope :regular_people_for_department, ->(department) {
    where('tags !~ ?', '(comite_animateur|comite_membre|\"lec\")').
        joins(:home_address).
        merge(Address.where('zip LIKE ?', "#{department}%"))
  }

  accepts_nested_attributes_for :home_address

  validates :people_id, uniqueness: true, allow_blank: true, unless: :skip_callbacks

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

    if (changed.map(&:to_s) & %w(email first_name last_name parent_id phone mobile tags)).present? || people_id.nil?
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
        new_tags = changes['tags'] ? JSON.parse(changes['tags'][1]) : []
        begin
          r = client.call(:people, :create, person: params)
        rescue => e
          Person.skip_callbacks = true
          update(nation_builder_error: JSON.parse(e.message)['code'])  #TODO see what errors look like
          Person.skip_callbacks = false
          return 
        end

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
    if people_id && !parent_id
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

  def is_departemental_comitees_manager?
    !!tags.match(/coordinateur_departemental/)
  end

  def departement_comitees_manager
    is_departemental_comitees_manager? && tags.match(/comite_coordinateur_departement_\d+/).to_s.gsub(/comite_coordinateur_departement_/, '').to_s
  end

  def departemental_manager
    Person.where('tags LIKE ?', "%comite_coordinateur_departement_#{home_address.zip}%")
  end

  def children_count
    children.length
  end

  def get_animator_for_department
    children = []
    if is_departemental_comitees_manager? && departement_comitees_manager
      children           += Person.animators_for_department(departement_comitees_manager).
          joins(%q(
            LEFT OUTER JOIN "user_to_person_relations"  ON "people"."id"  = "user_to_person_relations"."person_id"
            LEFT OUTER JOIN "users"                     ON "users"."id"   = "user_to_person_relations"."user_id"
          )).
          uniq.
          select('people.*, CASE WHEN users.id <> 0 THEN true ELSE false END "user_connected", contacted is null or contacted = false "already_contacted"')
    end
    children
  end

  def get_all_children
    return @children if @children
    children = []
    if is_departemental_comitees_manager? && departement_comitees_manager
      children           += Person.animators_for_department(departement_comitees_manager).
          joins(%q(
            LEFT OUTER JOIN "user_to_person_relations"  ON "people"."id"  = "user_to_person_relations"."person_id"
            LEFT OUTER JOIN "users"                     ON "users"."id"   = "user_to_person_relations"."user_id"
          )).
          uniq.
          select('people.*, CASE WHEN users.id <> 0 THEN true ELSE false END "user_connected", contacted is null or contacted = false "already_contacted"')
    end

    children           += self.children.activated.
        joins(%q(
          LEFT OUTER JOIN "user_to_person_relations"  ON "people"."id"  = "user_to_person_relations"."person_id"
          LEFT OUTER JOIN "users"                     ON "users"."id"   = "user_to_person_relations"."user_id"
        )).
        uniq.
        order("already_contacted DESC, last_name ASC").
        select('people.*, CASE WHEN users.id <> 0 THEN true ELSE false END "user_connected", contacted is null or contacted = false "already_contacted"')

    children.each{|c| c.user_connected = c.attributes['user_connected']}
    @children = children
  end

  def get_not_comite_people
    if is_departemental_comitees_manager? && departement_comitees_manager
      Person.regular_people_for_department(departement_comitees_manager).includes(:home_address)
    else
      []
    end
  end

  def self.get_all_coordinators
    User.joins(:people).merge(Person.where('tags like ?', '%coordinateur_departemental%')).uniq.order(:email).pluck(:email, :id)
  end

end