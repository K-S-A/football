'use strict'

angular.module('mainApp').directive 'myAddRound', [
  'Round'
  'Tournament'
  (Round, Tournament) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        new Round(mode: attrs.myAddRound, tournamentId: Tournament.current.id).create().then (data) ->
            Tournament.current.rounds.push(data)
]
