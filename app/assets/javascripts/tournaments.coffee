# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  pyramidal= ranking = pyramidal_set = ranking_set = max_players = false
  options = null

  language = $('#tournaments').data('language')
  $('#tournaments').dataTable(
    {
      "language": language,"jQueryUI": true
    })

  ranking_setter = (parent) ->
    parent.next().before ($("#general_mode").data("ranking"))
    $("#new_tournament").enableClientSideValidations()
    ranking_set = true

    if (pyramidal_set)
      $("#pyramidalMode").remove()
      pyramidal = false
      pyramidal_set = false

  options_remover = (selector, elements_delete) ->
    for elem in elements_delete
      $('#'+selector+' option[value="'+elem+'"]').remove()

  options_filter = (number_players, board_size) ->
    sel = "pyramidalMode"
    $('#pyramidalMode option').remove()
    $('#tournament_mode').append(options)
    if board_size == 4
      switch
        when (number_players == 3 or number_players == 4)
          options_remover(sel, [-2,1,2,3,4,5])
        when (number_players == 5)
          options_remover(sel, [-1,1,2,3,4,5])
        when (number_players >= 6 and number_players <= 8)
          options_remover(sel, [-2,-1,1,3,4,5])
        when (number_players > 8 and number_players <= 16)
          options_remover(sel, [-2,-1,3,4,5])
        when (number_players >16 or number_players < 3)
          options_remover(sel, [-1,1,2,3,4,5])
    else if board_size == 6
      switch
        when number_players > 3 and number_players <= 6
          options_remover(sel, [-2,1,2,3,4,5])
        when number_players > 6 and number_players <= 9
          options_remover(sel, [-2,-1,1,3,4,5])
        when number_players > 9 and number_players <= 12
          options_remover(sel, [-2,-1,1,4,5])
        when number_players > 12 and number_players <= 16
          options_remover(sel, [-2,-1,3,4,5])



  pyramidal_setter = (parent) ->
    parent.next().before ($("#general_mode").data("pyramidal"))
    $("#new_tournament").enableClientSideValidations()
    pyramidal_set = true
    options=$('#pyramidalMode option')
    num_players = parseInt($('#tournament_number_players').val(), 10)
    mode = parseInt($("#tournament_board_size").find(":selected").val(),10)

    options_filter(num_players,mode)

    if (ranking_set)
      $("#rankingRounds").remove()
      ranking = false
      ranking_set = false



  $("[id^='tournament_general_mode_']").on "click", (event)->
    target = event.currentTarget
    selected = $("#"+target.id)
    grandparent = $("#general_mode")

    if target.value == "0"
      ranking = true
      pyramidal = false
    else if target.value == "1"
      pyramidal = true
      ranking = false

    if (!max_players)

      grandparent.next().before ($("#general_mode").data("max-players"))
      max_players = true

      $("#tournament_number_players").bind "blur onchange oninput input", (event)->
        parent = $("#number_players")
        if (pyramidal)
          if pyramidal_set
            num_players = parseInt($('#tournament_number_players').val(), 10)
            mode = parseInt($("#tournament_board_size").find(":selected").val(),10)
            options_filter(num_players,mode)
          else
            pyramidal_setter(parent)
        else if (ranking && !ranking_set)
          ranking_setter(parent)
    else
      max_players_set = ($("#tournament_number_players").val()!="")
      # If a value was given for number_players do the following
      if (max_players_set)
        parent = $("#number_players")
        if target.value == "0" && !ranking_set
          ranking_setter(parent)
        else if target.value == "1" && !pyramidal_set
          pyramidal_setter(parent)
    selected.prop("checked",true)








