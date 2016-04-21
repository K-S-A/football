'use strict'

angular.module('mainApp').directive 'myTournamentStatusChange', [
  'Tournament'
  'Auth'
  (Tournament, Auth) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      scope.$watch 'tournament.status', (newVal, _oldVal) ->
        element.hide() if newVal == 'closed'

      element.on 'click', ->
        scope.tournament.prevStatus ||= scope.tournament.status

      element.on 'change', ->
        scope.tournament.update().then (data) ->
          scope.tournament = data
          scope.tournament.prevStatus = null
        , ->
          scope.tournament.status = scope.tournament.prevStatus

]
