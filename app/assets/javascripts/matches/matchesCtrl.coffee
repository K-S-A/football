'use strict'

angular.module('mainApp').controller 'MatchesCtrl', [
  'Match'
  (Match) ->
    vm = this

    vm.matches = Match.all

    vm
]
