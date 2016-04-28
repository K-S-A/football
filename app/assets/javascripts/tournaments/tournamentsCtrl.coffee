'use strict'

angular.module('mainApp').controller 'TournamentsCtrl', [
  'Tournament'
  'Auth'
  '$state'
  (Tournament, Auth, $state) ->
    vm = this

    vm.user = Auth._currentUser
    vm.tournaments = Tournament.all
    vm.tournament = Tournament.current
    vm.statuses = ['not started', 'in progress', 'completed']
    vm.sport_kinds = ['ping-pong', 'football']
    vm.team_sizes = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]

    vm.tournament.sports_kind ||= vm.sport_kinds[0]
    vm.tournament.team_size ||= vm.team_sizes[1]

    vm.create = ->
      new Tournament(vm.tournament).create().then (data) ->
        $state.go 'tournament.participants', id: data.id

    vm.delete = (index) ->
      vm.tournaments[index].delete().then ->
        vm.tournaments.splice(index, 1)

    vm
]
