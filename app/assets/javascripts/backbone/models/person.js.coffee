class StaticFiles.Models.Person extends Backbone.Model
  paramRoot: 'person'

  idAttribute: "id"

  defaults:
    first_name: null
    last_name: null
    email: null
    phone: null
    mobile: null
    home_address: null
    home_address_attributes: null
    people_id: 0
    profile_image_url_ssl: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAIAAADajyQQAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA69pVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYwIDYxLjEzNDc3NywgMjAxMC8wMi8xMi0xNzozMjowMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wUmlnaHRzPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvcmlnaHRzLyIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcFJpZ2h0czpNYXJrZWQ9IkZhbHNlIiB4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ9InV1aWQ6QjRDRkNGMjNDODNFREUxMUFEREZGQkYxRDU0OTAwMUUiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NjEzMTIxNjBEOUZDMTFERjgyQjREQjlFRkRFNTg2OUUiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NjEzMTIxNUZEOUZDMTFERjgyQjREQjlFRkRFNTg2OUUiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNSBNYWNpbnRvc2giPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDowNDgwMTE3NDA3MjA2ODExOEMzRUM2QzAwMUI4MzUxMCIg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"
    crm_checked: false
    tags: null
    animateur: false
    children_count: 0
    user_connected: false
    notes: null

  initialize: ->
    this.set_fullname()
    this.set_homeaddress()

  set_fullname: ->
    if this.get("email") == null
      this.set("full_name", "Erreur dans la fiche") # Normalement chaque fiche a au moins une adresse mail
    else
      if (this.get("first_name") == null) || (this.get("last_name") == null) || (this.get("first_name") == "") || (this.get("last_name") == "")
        this.set("full_name", "Fiche à compléter ("+this.get("email")+")") # Certaines n'ont pas de Nom / Prénom
      else
        this.set("full_name", this.get("first_name") + " " + this.get("last_name"))

  set_homeaddress: ->
    if this.get("home_address") == null
      this.set("home_address", {address1: '', address2: '', address3: '', zip: '', city: ''})
    else
      t_id = this.get("home_address").id
      t_address1 = if (this.get("home_address").address1 == null) then '' else  this.get("home_address").address1
      t_address2 = if (this.get("home_address").address2 == null) then '' else  this.get("home_address").address2
      t_address3 = if (this.get("home_address").address3 == null) then '' else  this.get("home_address").address3
      t_zip = if ((this.get("home_address").zip == null)||(this.get("home_address").zip == this.get("home_address").city)) then '' else  this.get("home_address").zip
      t_city = if (this.get("home_address").city == null) then '' else  this.get("home_address").city
      this.set("home_address", {id: t_id, address1: t_address1, address2: t_address2, address3: t_address3, zip: t_zip, city: t_city})
    this.set("home_address_attributes", this.get("home_address"))

  is_animateur: ->
    this.set("animateur", ((this.get("tags").search /"comite_animateur"/) >= 0))

class StaticFiles.Collections.PeopleCollection extends Backbone.Collection
  model: StaticFiles.Models.Person
  url: '/people'