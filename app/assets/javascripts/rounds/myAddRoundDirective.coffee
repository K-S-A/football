'use strict'

angular.module('mainApp').directive 'myAddRound', [
  'Round'
  'Tournament'
  (Round, Tournament) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        Round.createByTournament(Tournament.current.id,
          mode: attrs.myAddRound).then (data) ->
            Tournament.current.rounds.push(data)
]
