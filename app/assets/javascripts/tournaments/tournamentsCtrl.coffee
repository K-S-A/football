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
        vm.tournaments.push(data)
        vm.tournament = {}
        $state.go 'editTournament', id: data.id

    vm
]
