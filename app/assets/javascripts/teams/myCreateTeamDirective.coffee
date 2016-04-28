'use strict'

angular.module('mainApp').directive 'myCreateTeam', [
  '$uibModal'
  'Tournament'
  'Team'
  ($uibModal, Tournament, Team) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        modalInstance = $uibModal.open(
          templateUrl: 'teams/add_members.html'
          controller: 'TeamCtrl as vm'
          scope: scope
          size: 'lg'
          resolve: team: ['Team', (Team) ->
            Team.current = {}]
      )

        modalInstance.result.finally ->
          Team.current = {}
        .then (team) ->
          path = '/tournaments/' + Tournament.current.id + '/teams'
          Team.$post(path, team).then (data) ->
            Tournament.current.teams.unshift(data)

]
