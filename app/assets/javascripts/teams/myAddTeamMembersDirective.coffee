'use strict'

angular.module('mainApp').directive 'myAddTeamMembers', [
  '$uibModal'
  'Tournament'
  'Team'
  ($uibModal, Tournament, Team) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        modalInstance = $uibModal.open(
          templateUrl: 'teams/add_members.html'
          controller: 'MembersCtrl as vm'
          scope: scope
          size: 'lg'
          resolve: team: ['Team', (Team) ->
            Team.current = scope.team]
      )

        modalInstance.result.finally ->
          Team.current = {}
        .then (team) ->
          team.update().then (data) ->
            Tournament.current.teams[scope.$index] = data

]
