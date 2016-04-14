'use strict'

angular.module('mainApp').directive 'myAuthorized', [
  'Auth'
  (Auth) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      if Auth._currentUser && Auth._currentUser.admin
        element.show()
      else
        element.hide()
]
