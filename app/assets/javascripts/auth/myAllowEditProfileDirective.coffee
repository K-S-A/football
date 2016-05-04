'use strict'

angular.module('mainApp').directive 'myAllowEditProfile', [
  'Team'
  'Auth'
  (Team, Auth) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      unless Auth.isAuthenticated() && (Auth._currentUser.admin || scope.vm.user.id == Auth._currentUser.id)
        element.hide()

]
