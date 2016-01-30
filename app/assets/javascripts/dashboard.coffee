$(document).ready ->
  $("#alert-messages").children().each (index, element) ->
    setTimeout ->
      $(element).fadeOut(1000)
    , 3000
    setTimeout ->
      $(element).remove()
    , 5000

  ((proxied) ->

    window.alert = ->
      $('#alert-messages').append '<div class="alert alert-danger">'+filterXSS(arguments[0])+'</div>'
      $("#alert-messages").children().each (index, element) ->
        setTimeout ->
          $(element).fadeOut(1000)
        , 3000
        setTimeout ->
          $(element).remove()
        , 5000

    return
  ) window.alert