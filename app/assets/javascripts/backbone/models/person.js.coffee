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

  initialize: ->
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
            window.peopleCollection.add(person, {merge: true})
            window.peopleView.render()
            if parseInt(window.location.hash.substr(1)) == person.get("people_id")
              window.personView = new StaticFiles.Views.People.ShowView({el: '#person', model: person})
              window.personView.render()