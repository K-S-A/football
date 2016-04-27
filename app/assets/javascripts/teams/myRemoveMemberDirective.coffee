'use strict'

angular.module('mainApp').directive 'myRemoveMember', [
  'Tournament'
  'Team'
  (Tournament, Team) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        if scope.team.users.length is 1
          scope.team.delete().then ->
            Tournament.current.teams.splice(scope.$parent.$index, 1)
        else
          Team.$delete('/teams/' + scope.team.id, user_id: scope.member.id).then (data) ->
            scope.team.users.splice(scope.$index, 1)

]
