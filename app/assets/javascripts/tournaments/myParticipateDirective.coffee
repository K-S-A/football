'use strict'

angular.module('mainApp').directive 'myParticipate', [
  'Tournament'
  'Auth'
  (Tournament, Auth) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        scope.tournament.users.push(Auth._currentUser)
        scope.tournament.update().then ->
          element.hide()
]
