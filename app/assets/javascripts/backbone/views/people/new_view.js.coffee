StaticFiles.Views.People ||= {}

class StaticFiles.Views.People.NewView extends Backbone.View
  template: JST["backbone/templates/people/new"]

  events:
    "submit #new-person": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

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

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
