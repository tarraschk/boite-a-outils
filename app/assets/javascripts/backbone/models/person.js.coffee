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

class StaticFiles.Collections.PeopleCollection extends Backbone.Collection
  model: StaticFiles.Models.Person
  url: '/people'
