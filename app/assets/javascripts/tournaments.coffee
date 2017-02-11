# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  pyramidal= ranking = false

  language = $('#tournaments').data('language')
  $('#tournaments').dataTable(
    {
      "language": language,"jQueryUI": true
    });

  $("[id^='tournament_general_mode_']").on "click", (event)->
    target = event.currentTarget
    selected = $("#"+target.id)
    parent = $("#general_mode")
    if target.value == "0"
      if (!ranking)
        parent.next().before ($("#general_mode").data("ranking"))
        parent.next().children().last().enableClientSideValidations()
        ranking = true
      if (pyramidal)
        $("#pyramidalMode").remove()
        pyramidal = false
    else if target.value == "1"
      if (!pyramidal)
        parent.next().before ($("#general_mode").data("pyramidal"))
        parent.next().children().last().enableClientSideValidations()
        pyramidal = true
      if (ranking)
        $("#rankingRounds").remove()
        ranking = false
    selected.prop("checked",true)






