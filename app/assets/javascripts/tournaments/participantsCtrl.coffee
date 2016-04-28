'use strict'

angular.module('mainApp').controller 'ParticipantsCtrl', [
  '$uibModalInstance'
  'Tournament'
  'User'
  ($uibModalInstance, Tournament, User) ->
    vm = this

    vm.participants = angular.copy(Tournament.current.users)
    vm.users = User.unsubscribed
    vm.teams = Tournament.current.teams

    vm.moveUser = (from, to, index) ->
      to.push(from.splice(index, 1)[0])

    vm.close = ->
      $uibModalInstance.close(vm.participants)

    vm.cancel = ->
      $uibModalInstance.dismiss('cancel')
    vm
]
