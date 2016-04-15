'use strict'

angular.module('mainApp').controller 'RoundsCtrl', [
  'Round'
  (Round) ->
    vm = this

    vm.round = Round.current

    vm
]
