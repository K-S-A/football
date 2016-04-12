'use strict'

angular.module('mainApp').directive 'myRemoveAllTeams', [
  'Tournament'
  'Team'
  (Tournament, Team) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        Team.$delete(
          '/teams/all'
          tournament_id: Tournament.current.id).then ->
            Tournament.current.teams = []
]
