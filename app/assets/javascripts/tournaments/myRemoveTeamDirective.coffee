'use strict'

angular.module('mainApp').directive 'myRemoveTeam', [
  'Tournament'
  'Team'
  (Tournament, Team) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        index = scope.$index

        scope.team.delete().then (data) ->
            Tournament.current.teams.splice(index, 1)
]
