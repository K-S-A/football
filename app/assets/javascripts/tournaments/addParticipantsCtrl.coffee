'use strict'

angular.module('mainApp').controller 'AddParticipantsCtrl', [
  '$uibModalInstance'
  'Tournament'
  'users'
  ($uibModalInstance, Tournament, users) ->
    vm = this

    vm.participants = angular.copy(Tournament.current.users)
    vm.users = users
    vm.teams = Tournament.current.teams

    # TODO - ...
    vm.moveUser = (index, add) ->
      if add
        [from, to] = [vm.users, vm.participants]
      else
        [to, from] = [vm.users, vm.participants]
        user = from[index]
        vm.teams.forEach (t, i) ->
          t.users.forEach (u) ->
            if u.id is user.id
              t.delete().then ->
                vm.teams.splice(i, 1)

      to.push(from.splice(index, 1)[0])

    vm.close = ->
      $uibModalInstance.close(vm.participants)

    vm.cancel = ->
      $uibModalInstance.dismiss('cancel')
    vm
]
