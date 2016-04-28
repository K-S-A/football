'use strict'

angular.module('mainApp').directive 'myDeleteRoundTeam', [
  'Round'
  '$window'
  (Round, $window) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        if $window.confirm('Remove team?')
          Round.$patch('/rounds/' + scope.vm.round.id, teamId: scope.team.id).then (data) ->
            Round.current.teams = data.teams
]
