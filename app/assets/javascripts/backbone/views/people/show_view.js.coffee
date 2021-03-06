StaticFiles.Views.People ||= {}

class StaticFiles.Views.People.ShowView extends Backbone.View
  template: JST["backbone/templates/people/show"]

  events:
    "click #button-contacted-person" : "update_contacted",
    "click #button-edit-person" : "edit_person"

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this

  update_contacted: ->
    if (parseInt(window.location.hash.substr(1)) == @model.get("id"))
      @model.set("contacted", !@model.get("contacted"))
      @model.save({"contacted": @model.get("contacted")}, {
        patch: true,
        success: (person, response) ->
          window.peopleCollection.add(person, {merge: true})
          window.peopleView.unbind()
          window.peopleView.render()
          window.personView.unbind()
          window.stopZombies(window.personView)
          window.personView = new StaticFiles.Views.People.ShowView({el: '#person', model: person})
          window.personView.render()
        error: (person, response) ->
          window.stopZombies(window.personView)
      })
    return false

  edit_person: ->
    window.stopZombies(window.personView)
    window.personView = new StaticFiles.Views.People.EditView({el: '#person', model: @model})
    window.personView.render()
    return false