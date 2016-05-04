'use strict'

angular.module('mainApp').directive 'myAllowEditTeam', [
  'Team'
  'Auth'
  (Team, Auth) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      unless Auth.isAuthenticated() && (Auth._currentUser.admin || scope.vm.team.includeMember(Auth._currentUser))
        element.hide()

]
