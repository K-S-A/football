'use strict'

angular.module('mainApp').directive 'mySwapTeams', [
  'Match'
  'Round'
  (Match, Round) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        match = angular.copy(scope.match)
        match.roundId = Round.current.id
        [match.hostTeamId, match.guestTeamId] = [match.guestTeam.id, match.hostTeam.id]

        match.update().then (data) ->
          scope.match = data
]
