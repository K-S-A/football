'use strict'

angular.module('mainApp').directive 'myRemoveMember', [
  'Tournament'
  'Team'
  (Tournament, Team) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        Team.$delete('/teams/' + scope.team.id + '/users/' + scope.member.id).then ->
          scope.team.users.splice(scope.$index, 1)

]
