StaticFiles.Views.People ||= {}

class StaticFiles.Views.People.EditView extends Backbone.View
  template: JST["backbone/templates/people/edit"]

  events:
    "click #button-update-person": "update"
    "click #button-back-person" : "cancel"

  update: ->
    if (parseInt(window.location.hash.substr(1)) == @model.get("people_id")) && (!window.params.semaphore.updates)
      window.params.semaphore.updates = true
      @model.set({
        "first_name": $("input[name='first_name']").val(),
        "last_name": $("input[name='last_name']").val(),
        "email": $("input[name='email']").val(),
        "phone": $("input[name='phone']").val(),
        "mobile": $("input[name='mobile']").val()
      })
      @model.save({
        "first_name": @model.get("first_name"),
        "last_name": @model.get("last_name"),
        "email": @model.get("email"),
        "phone": @model.get("phone"),
        "mobile": @model.get("mobile")
      }, {
        patch: true,
        success: (person, response) ->
          window.peopleCollection.add(person, {merge: true})
          window.peopleView.unbind()
          window.peopleView.render()
          window.personView.unbind()
          window.personView = new StaticFiles.Views.People.ShowView({el: '#person', model: person})
          window.personView.render()
          window.params.semaphore.updates = false
        error: (person, response) ->
          window.params.semaphore.updates = false
      })
    return false

  cancel: ->
    window.personView.unbind()
    window.personView = new StaticFiles.Views.People.ShowView({el: '#person', model: @model})
    window.personView.render()
    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
