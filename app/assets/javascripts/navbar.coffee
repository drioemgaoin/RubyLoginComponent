$(document).ready ->
  $('.toggle').click ->
    $(this).parent().toggleClass('active')
    false
  return
