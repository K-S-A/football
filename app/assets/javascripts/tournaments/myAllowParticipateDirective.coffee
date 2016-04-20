'use strict'

angular.module('mainApp').directive 'myAllowParticipate', [
  'Auth'
  'Tournament'
  (Auth, Tournament) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      if Auth._currentUser && scope.tournament.isOpen() && !scope.tournament.includeUser(Auth._currentUser)
        element.show()
      else
        element.hide()
]
