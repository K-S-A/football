'use strict'

angular.module('mainApp').controller 'RoundsCtrl', [
  'Round'
  'Tournament'
  (Round, Tournament) ->
    vm = this

    vm.round = Round.current
    vm.rounds = Tournament.current.rounds

    vm
]
