StaticFiles.Views.People ||= {}

class StaticFiles.Views.People.IndexView extends Backbone.View
  template: JST["backbone/templates/people/index"]

  initialize: () ->
    @collection.bind('reset', @addAll)

  addAll: () =>
    @collection.each(@addOne)

  addOne: (person) =>
    view = new StaticFiles.Views.People.PersonView({model : person})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(people: @collection.toJSON() ))
    @addAll()

    return this
