class StaticFiles.Models.Person extends Backbone.Model
  paramRoot: 'person'

  idAttribute: "people_id"

  defaults:
    first_name: null
    last_name: null
    email: null
    phone: null
    mobile: null
    home_address: null
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