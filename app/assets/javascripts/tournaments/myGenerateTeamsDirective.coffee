'use strict'

angular.module('mainApp').directive 'myGenerateTeams', [
  'Tournament'
  'Team'
  (Tournament, Team) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        Team.$post(
          '/tournaments/' + Tournament.current.id + '/teams'
          team_size: Tournament.current.teamSize).then (data) ->
            data.forEach (t) ->
              Tournament.current.teams.push(t)
]
