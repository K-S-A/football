'use strict'

angular.module('mainApp').controller 'RoundsCtrl', [
  'Round'
  (Round) ->
    vm = this

    vm.round = Round.current
#    vm.create = ->
#      new Tournament(vm.tournament).create().then (data) ->
#        $state.go 'tournament.participants', id: data.id

#    vm.delete = (index) ->
#      vm.tournaments[index].delete().then ->
#        vm.tournaments.splice(index, 1)

#    vm.toTitle = (tournament) ->
#      Tournament.toTitle(tournament)

    vm
]
