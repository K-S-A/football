'use strict'

angular.module('mainApp').directive 'myAddRound', [
  'Round'
  'Tournament'
  '$state'
  (Round, Tournament, $state) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        new Round(mode: attrs.myAddRound, tournamentId: Tournament.current.id).create().then (data) ->
          Tournament.current.rounds.push(data)
          $state.go('tournament.rounds.show', round_id: data.id)
]
