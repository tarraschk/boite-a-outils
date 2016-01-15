StaticFiles.Views.People ||= {}

class StaticFiles.Views.People.PersonView extends Backbone.View
  template: JST["backbone/templates/people/person"]

  events:
    "click .destroy" : "destroy"
    "click" : "select"

  select: () ->
    $("#dashboard").addClass("hidden")
    $("#person").removeClass("hidden")
    selector = "a[data-id="+@model.id+"]"
    $("#people").find("li").removeClass("selected")
    $(selector).children("li").addClass("selected")
    window.personView = new StaticFiles.Views.People.ShowView({el: '#person', model: @model});
    window.personView.render()
    console.log window.personView
    return false

  destroy: () ->
    @model.destroy()
    this.remove()
    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this