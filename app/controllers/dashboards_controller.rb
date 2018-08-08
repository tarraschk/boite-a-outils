class DashboardsController < SignedInController
  def dashboard
    if user_signed_in?
      @children           = current_person.children.activated
      @parent             = current_person.parent
    end
  end

  class ContactListInfo
    attr_accessor :attributes

    def initialize(p)
      self.attributes = p[:attributes]
    end

    [:prenom, :nom, :email, :telephone, :mobile, :adresse, :ville, :membre_de_comité, :zip, :nom_de_l_animateur].each do |method|
      define_method(method) {attributes[method]}
    end
  end

  def print_contact_list
    children           = Person.activated.where("tags SIMILAR TO '%(comite_animateur|comite_membre)%'").where('people.id IN (?) or people.parent_id IN (?)', current_person.get_all_children.map(&:id), current_person.get_all_children.map(&:people_id)).includes(:home_address)
    all_people = children.uniq
    animators = Hash[Person.where(people_id: all_people.map(&:parent_id)).pluck('people_id', "first_name || ' ' || last_name")]
    data = all_people.map do |child|
      attributes = {
          prenom:           child.first_name,
          nom:              child.last_name,
          email:            child.email,
          telephone:        child.phone,
          mobile:           child.mobile,
          adresse:          child.home_address && "#{child.home_address.address1} #{child.home_address.address2}",
          ville:            child.home_address && child.home_address.city,
          zip:              child.home_address && child.home_address.zip
      }
      if current_person.is_departemental_comitees_manager? && current_person.departement_comitees_manager
        attributes.merge!(nom_de_l_animateur: animators[child.parent_id])
      end
      ContactListInfo.new(attributes: attributes)
    end
    ExtractDownloadLog.create(user_id: current_user.id, export_type: 1)
    send_data(data.to_xls, type: 'application/excel; charset=utf-8; header=present', filename: 'Mes contacts.xls')
  end

  def print_contact_list_department
    regular_people     = current_person.get_not_comite_people
    all_people = regular_people.uniq
    data = all_people.map do |child|
      ContactListInfo.new(attributes: {
          prenom:           child.first_name,
          nom:              child.last_name,
          email:            child.email,
          telephone:        child.phone,
          mobile:           child.mobile,
          adresse:          child.home_address && "#{child.home_address.address1} #{child.home_address.address2}",
          ville:            child.home_address && child.home_address.city,
          zip:              child.home_address && child.home_address.zip,
          #membre_de_comité: child.tags && child.tags.match(/(comite_animateur|comite_membre)/) ? 'oui' : 'non'
      })
    end
    ExtractDownloadLog.create(user_id: current_user.id, export_type: 2)
    send_data(data.to_xls, type: 'application/excel; charset=utf-8; header=present', filename: 'Sympathisants du département.xls')
  end
end