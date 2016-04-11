'use strict'

angular.module('mainApp').directive 'myParticipate', [
  'Tournament'
  'Auth'
  (Tournament, Auth) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      scope.tournament.users.forEach (u) ->
        if Auth._currentUser and u.id is Auth._currentUser.id
          element.hide()
      element.on 'click', ->
        scope.tournament.users.push(Auth._currentUser)
        scope.tournament.update().then ->
          element.hide()
]
