'use strict'

angular.module('mainApp').controller 'TeamsCtrl', [
  'Tournament'
  'Team'
  (Tournament, Team) ->
    vm = this

    vm.tournament = Tournament.current

    vm
]
