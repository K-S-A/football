'use strict'

angular.module('mainApp').directive 'myRemoveTeam', [
  'Tournament'
  'Team'
  '$window'
  (Tournament, Team, $window) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        if $window.confirm('Remove team?')
          index = scope.$index

          scope.team.delete().then (data) ->
              Tournament.current.teams.splice(index, 1)
]
