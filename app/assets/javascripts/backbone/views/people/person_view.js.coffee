StaticFiles.Views.People ||= {}

class StaticFiles.Views.People.PersonView extends Backbone.View
  template: JST["backbone/templates/people/person"]

  events:
    "click .destroy" : "destroy"
    "click" : "select"

  select: () ->
    $("#dashboard").addClass("hidden")
    $("#person").addClass("hidden")
    $("#person-loading").removeClass("hidden")
    selector = "a[data-id="+@model.id+"]"
    $("#people").find("li").removeClass("selected")
    $(selector).children("li").addClass("selected")
    if @model.get("original_id")
      window.personView = new StaticFiles.Views.People.ShowView({el: '#person', model: @model})
      window.personView.render()
      $("#person").removeClass("hidden")
      $("#person-loading").addClass("hidden")
    else
      window.personView = new StaticFiles.Views.People.ShowView({el: '#person', model: @model})
      window.personView.render()
      $("#person").removeClass("hidden")
      $("#person-loading").addClass("hidden")
      @model.fetch
        success: (person, response) ->
          console.log person
          window.peopleCollection.add(person, {merge: true})
          window.peopleView.render()
          window.personView = new StaticFiles.Views.People.ShowView({el: '#person', model: person})
          window.personView.render()
    return true

  destroy: () ->
    @model.destroy()
    this.remove()
    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
