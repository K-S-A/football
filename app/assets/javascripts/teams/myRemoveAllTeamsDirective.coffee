'use strict'

angular.module('mainApp').directive 'myRemoveAllTeams', [
  'Tournament'
  'Team'
  '$window'
  (Tournament, Team, $window) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        if $window.confirm('Remove all teams?')
          Team.$delete(
            '/teams/all'
            tournament_id: Tournament.current.id).then ->
              Tournament.current.teams = []
]
