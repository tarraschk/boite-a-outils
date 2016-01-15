StaticFiles.Views.People ||= {}

class StaticFiles.Views.People.IndexView extends Backbone.View
  template: JST["backbone/templates/people/index"]

  initialize: () ->
    @collection.bind('reset', @addAll)
    console.log @collection

  addAll: () =>
    @collection.each(@addOne)

  addOne: (person) =>
    view = new StaticFiles.Views.People.PersonView({model : person})
    @$("ul").append(view.render().el)

  render: =>
    @$el.parent().children(".loading").addClass("hidden")
    @$el.html(@template(people: @collection.toJSON() ))
    @addAll()

    return this
