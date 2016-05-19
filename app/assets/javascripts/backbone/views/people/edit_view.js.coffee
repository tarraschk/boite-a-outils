StaticFiles.Views.People ||= {}

class StaticFiles.Views.People.EditView extends Backbone.View
  template: JST["backbone/templates/people/edit"]

  events:
    "click #button-update-person": "update"
    "click #button-back-person" : "cancel"

  update: ->
    if (parseInt(window.location.hash.substr(1)) == @model.get("id")) && (true)
      @model.set({
        "first_name": $("input[name='person[first_name]']").val(),
        "last_name": $("input[name='person[last_name]']").val(),
        "email": $("input[name='person[email]']").val(),
        "phone": $("input[name='person[phone]']").val(),
        "mobile": $("input[name='person[mobile]']").val(),
        "home_address": {
          id: $("input[name='person[home_address_attributes][id]']").val(),
          address1: $("input[name='person[home_address_attributes][address1]']").val(),
          address2: $("input[name='person[home_address_attributes][address2]']").val(),
          address3: $("input[name='person[home_address_attributes][address3]']").val(),
          zip: $("input[name='person[home_address_attributes][zip]']").val(),
          city: $("input[name='person[home_address_attributes][city]']").val()
        }
      })
      @model.save({
        "first_name": @model.get("first_name"),
        "last_name": @model.get("last_name"),
        "email": @model.get("email"),
        "phone": @model.get("phone"),
        "mobile": @model.get("mobile"),
        "home_address": @model.get("home_address")
        "home_address_attributes": @model.get("home_address")
      }, {
        patch: true,
        success: (person, response) ->
          person.set_fullname()
          window.peopleCollection.add(person, {merge: true})
          window.peopleView.unbind()
          window.peopleView.render()
          window.stopZombies(window.personView)
          window.personView = new StaticFiles.Views.People.ShowView({el: '#person', model: person})
          window.personView.render()
        error: (person, response) ->
          alert "Erreur, veuillez vérifier vos données.<br/>Information technique : "+response
          window.stopZombies(window.personView)
      })
    return false

  cancel: ->
    window.personView.unbind()
    window.stopZombies(window.personView)
    window.personView = new StaticFiles.Views.People.ShowView({el: '#person', model: @model})
    window.personView.render()
    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
