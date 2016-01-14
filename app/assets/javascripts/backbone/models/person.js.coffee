class StaticFiles.Models.Person extends Backbone.Model
  paramRoot: 'person'

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
    profile_image_url_ssl: "images/empty_profile.gif"

  initialize: ->
    console.log this
    this.set({
      "address_address1": this.get("primary_address")["address1"],
      "address_address2": this.get("primary_address")["address2"],
      "address_address3": this.get("primary_address")["address3"],
      "address_city": this.get("primary_address")["city"],
      "address_state": this.get("primary_address")["state"],
      "address_zip": this.get("primary_address")["zip"],
      "address_country_code": this.get("primary_address")["country_code"],
      "address_lat": this.get("primary_address")["lat"],
      "address_lng": this.get("primary_address")["lng"]
    })

class StaticFiles.Collections.PeopleCollection extends Backbone.Collection
  model: StaticFiles.Models.Person
  url: '/people'
