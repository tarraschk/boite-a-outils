class StaticFiles.Routers.PeopleRouter extends Backbone.Router
  initialize: (options) ->
    @people = new StaticFiles.Collections.PeopleCollection()
    @people.reset options.people

  routes:
    "new"      : "newPerson"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newPerson: ->
    @view = new StaticFiles.Views.People.NewView(collection: @people)
    $("#people").html(@view.render().el)

  index: ->
    @view = new StaticFiles.Views.People.IndexView(collection: @people)
    $("#people").html(@view.render().el)

  show: (id) ->
    person = @people.get(id)

    @view = new StaticFiles.Views.People.ShowView(model: person)
    $("#people").html(@view.render().el)

  edit: (id) ->
    person = @people.get(id)

    @view = new StaticFiles.Views.People.EditView(model: person)
    $("#people").html(@view.render().el)
