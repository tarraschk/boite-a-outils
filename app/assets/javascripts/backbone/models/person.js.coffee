class StaticFiles.Models.Person extends Backbone.Model
  paramRoot: 'person'

  idAttribute: "people_id"

  defaults:
    first_name: null
    last_name: null
    email: null
    phone: null
    mobile: null
    address_address1: null
    address_address2: null
    address_address3: null
    address_city: null
    address_state: null
    address_zip: null
    address_country_code: null
    address_lat: null
    address_lng: null
    profile_image_url_ssl: "images/loading.gif"
    crm_checked: false

  initialize: ->
    if this.get("email") == null
      this.set("full_name", "Erreur dans la fiche") # Normalement chaque fiche a au moins une adresse mail
    else
      if (this.get("first_name") == null) || (this.get("last_name") == null) || (this.get("first_name") == "") || (this.get("last_name") == "")
        this.set("full_name", "Fiche à compléter ("+this.get("email")+")") # Certaines n'ont pas de Nom / Prénom
      else
        this.set("full_name", this.get("first_name") + " " + this.get("last_name"))
    ###this.set({
      "address_address1": this.get("primary_address")["address1"],
      "address_address2": this.get("primary_address")["address2"],
      "address_address3": this.get("primary_address")["address3"],
      "address_city": this.get("primary_address")["city"],
      "address_state": this.get("primary_address")["state"],
      "address_zip": this.get("primary_address")["zip"],
      "address_country_code": this.get("primary_address")["country_code"],
      "address_lat": this.get("primary_address")["lat"],
      "address_lng": this.get("primary_address")["lng"]
    })###

class StaticFiles.Collections.PeopleCollection extends Backbone.Collection
  model: StaticFiles.Models.Person
  url: '/people'

  fetchFromNationBuilder: ->
    this.each (person) ->
      if !person.get("original_id")
        person.fetch
          success: (person, response) ->
            if person.get("full_name") == "" # Cas des fiches NB sans Nom / Prénom (qui sont courantes !)
              person.set("full_name", "Fiche à compléter ("+person.get("email")+")")
            window.peopleCollection.add(person, {merge: true})
            window.peopleView.unbind()
            window.peopleView.render()
            if parseInt(window.location.hash.substr(1)) == person.get("people_id")
              window.personView = new StaticFiles.Views.People.ShowView({el: '#person', model: person})
              window.personView.unbind()
              window.personView.render()