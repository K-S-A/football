'use strict'

angular.module('mainApp').controller 'TeamCtrl', [
  '$uibModalInstance'
  'Tournament'
  'Team'
  ($uibModalInstance, Tournament, Team) ->
    vm = this

    vm.team =
      name: ''
      users: []

    vm.members = vm.team.users
    vm.users = angular.copy(Tournament.current.users)

    vm.moveUser = (from, to, index) ->
      to.push(from.splice(index, 1)[0])

    vm.generateName = ->
      vm.team.name = vm.members.map (m) ->
        m.firstName + ' ' + m.lastName[0] + '.'
      .join(' + ')

    vm.close = ->
      $uibModalInstance.close(vm.team)

    vm.cancel = ->
      $uibModalInstance.dismiss('cancel')
    vm
]
