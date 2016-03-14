StaticFiles.Views.People ||= {}

class StaticFiles.Views.People.PersonView extends Backbone.View
  template: JST["backbone/templates/people/person"]

  events:
    "click .destroy" : "destroy"
    "click" : "select"
    "click input[name='people-checkbox']" : "check"

  select: () ->
    $("#dashboard").addClass("hidden")
    $("#person").addClass("hidden")
    $("#person-loading").removeClass("hidden")
    selector = "a[href="+@model.id+"]"
    $("#people").find("li").removeClass("selected")
    $(selector).children("li").addClass("selected")
    window.stopZombies(window.personView)
    window.personView = new StaticFiles.Views.People.ShowView({el: '#person', model: @model})
    window.personView.render()
    $("#person").removeClass("hidden")
    $("#person-loading").addClass("hidden")
    return true

  check: () ->
    @model.set("crm_checked", !@model.get("crm_checked"))

  destroy: () ->
    @model.destroy()
    this.remove()
    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
