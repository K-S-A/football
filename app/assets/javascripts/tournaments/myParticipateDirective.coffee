'use strict'

angular.module('mainApp').directive 'myParticipate', [
  'Tournament'
  'Auth'
  (Tournament, Auth) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      scope.$watch('tournament.status', (newVal, oldVal) ->
        if !scope.tournament.isOpen() || !Auth.isAuthenticated() || scope.tournament.includeUser(Auth._currentUser)
          element.hide()
        else
          element.show())

      element.on 'click', ->
        tournament = angular.copy(scope.tournament)
        tournament.users.push(Auth._currentUser)
        tournament.update().then (data) ->
          scope.tournament = data
          element.hide()
]
