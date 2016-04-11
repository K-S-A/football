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

    vm.create = ->
      new Tournament(vm.tournament).create().then (data) ->
        $state.go 'tournament.participants', id: data.id

    vm.delete = (index) ->
      vm.tournaments[index].delete().then ->
        vm.tournaments.splice(index, 1)

    vm.toTitle = (tournament) ->
      Tournament.toTitle(tournament)

    vm
]
