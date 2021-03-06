StaticFiles.Views.People ||= {}

class StaticFiles.Views.People.NewView extends Backbone.View
  template: JST["backbone/templates/people/new"]

  events:
    "click #button-save-person": "save"
    "click #button-back-person" : "cancel"

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    window.params.semaphore.updates = true
    $("#form-new-contact").formValidation({
      framework: 'bootstrap',
      icon: {
        valid: 'glyphicon glyphicon-ok',
        invalid: 'glyphicon glyphicon-remove',
        validating: 'glyphicon glyphicon-refresh'
      },
      fields: {
        contact_infos: {
          selector: '.contact_info',
          validators: {
            callback: {
              message: 'Vous devez rentrer au moins un moyen de contact',
              callback: (value, validator, $field) ->
                isEmpty = true
                $fields = validator.getFieldElements('contact_infos');
                doCheck = (field) ->
                  if($(field).val() != '')
                    isEmpty = isEmpty && false
                doCheck(field) for field in $fields
                if(!isEmpty)
                  validator.updateStatus('contact_infos', validator.STATUS_VALID, 'callback');
                  return true;
                else
                  validator.updateStatus('contact_infos', validator.STATUS_INVALID, 'callback');
                  return false;
              }
          }
        }
      }
    })
    $("#form-new-contact").data('formValidation').validate()
    if $("#form-new-contact").data('formValidation').isValid()
      $.post("/people", $("form").serialize())
      .success (data) ->
        person = new StaticFiles.Models.Person(data)
        window.peopleCollection.add(person, {merge: true})
        window.peopleView.unbind()
        window.peopleView.render()
        window.personView.unbind()
        window.stopZombies(window.personView)
        window.personView = new StaticFiles.Views.People.ShowView({el: '#person', model: person})
        window.personView.render()
        window.params.semaphore.updates = false
        return
      .error (person, response) ->
        alert "Erreur, veuillez vérifier vos données.<br/>Information technique : "+response
        window.params.semaphore.updates = false
        return


  cancel: ->
    window.functionsAjxCrm.getHome()
    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
