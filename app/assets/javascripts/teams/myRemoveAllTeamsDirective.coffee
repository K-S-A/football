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
          Team.$delete('/tournaments/' + Tournament.current.id + '/teams').then ->
            Tournament.current.teams = []
]
