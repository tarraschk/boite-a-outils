StaticFiles.Views.People ||= {}

class StaticFiles.Views.People.NewView extends Backbone.View
  template: JST["backbone/templates/people/new"]

  events:
    "click #button-save-person": "save"
    "click #button-back-person" : "cancel"

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (person) =>
        @model = person
        window.location.hash = "/#{@model.id}"

      error: (person, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  cancel: ->
    window.functionsAjxCrm.getHome()
    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
