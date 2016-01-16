$(document).ready ->
  $("#alert-messages").children().each (index, element) ->
    setTimeout ->
      $(element).fadeOut(1000)
    , 3000
    setTimeout ->
      $(element).remove()
    , 5000