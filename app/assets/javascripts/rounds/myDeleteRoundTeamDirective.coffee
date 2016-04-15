'use strict'

angular.module('mainApp').directive 'myDeleteRoundTeam', [
  'Round'
  (Round) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        Round.$delete('/rounds/' + scope.vm.round.id, teamId: scope.team.id).then (data) ->
          Round.current.teams = data.teams
]
