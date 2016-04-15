'use strict'

angular.module('mainApp').directive 'myAddRoundTeams', [
  '$uibModal'
  'Tournament'
  'Round'
  ($uibModal, Tournament, Round) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        modalInstance = $uibModal.open(
          templateUrl: 'rounds/add_teams.html'
          controller: 'AddRoundTeamsCtrl as vm'
          scope: scope
          size: 'lg'
          resolve: teams: ['Round', 'Tournament', (Round, Tournament) ->
            teams = []
            round_team_ids = Round.current.teams.map (team) ->
              team.id

            Tournament.current.teams.forEach (team) ->
              if round_team_ids.indexOf(team.id) is -1
                teams.push(team)

            Round.current.unsubscribed = teams]
        )

        modalInstance.result.then (teams) ->
          path = '/rounds/' + Round.current.id
          params = Round.current
          params.teams = teams
          Round.$patch(path, params).then (data) ->
            Round.current.teams = data.teams

]
