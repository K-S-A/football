'use strict'

angular.module('mainApp').controller 'AddRoundTeamsCtrl', [
  'Round'
  '$uibModalInstance'
  (Round, $uibModalInstance) ->
    vm = this

    vm.teams = angular.copy(Round.current.unsubscribed)
    vm.selected_teams = angular.copy(Round.current.teams)

    vm.addTeam = (index) ->
      team = vm.teams.splice(index, 1)[0]
      vm.selected_teams.push(team)

    vm.close = ->
      $uibModalInstance.close(vm.selected_teams)

    vm.cancel = ->
      $uibModalInstance.dismiss('cancel')

    vm
]




