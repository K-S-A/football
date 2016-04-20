'use strict'

angular.module('mainApp').directive 'myParticipate', [
  'Tournament'
  'Auth'
  (Tournament, Auth) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      if Auth._currentUser && scope.tournament.isOpen() && !scope.tournament.includeUser(Auth._currentUser)
        element.show()
      else
        element.hide()

      element.on 'click', ->
        scope.tournament.users.push(Auth._currentUser)
        scope.tournament.update().then ->
          element.hide()
]
