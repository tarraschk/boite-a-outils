StaticFiles.Views.People ||= {}

class StaticFiles.Views.People.ShowView extends Backbone.View
  template: JST["backbone/templates/people/show"]

  events:
    "click #button-contacted-person" : "update_contacted"

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this

  update_contacted: ->
    if (parseInt(window.location.hash.substr(1)) == @model.get("people_id")) && (!window.params.semaphore.updates)
      window.params.semaphore.updates = true
      @model.set("contacted", !@model.get("contacted"))
      @model.save({"contacted": @model.get("contacted")}, {
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