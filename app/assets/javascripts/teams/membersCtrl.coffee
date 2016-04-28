'use strict'

angular.module('mainApp').controller 'MembersCtrl', [
  '$uibModalInstance'
  'Tournament'
  'Team'
  ($uibModalInstance, Tournament, Team) ->
    vm = this

    vm.team = angular.copy(Team.current)
    vm.members = vm.team.users

    vm.member_ids = vm.members.map (u) ->
      u.id

    vm.users = Tournament.current.users.filter (u) ->
      vm.member_ids.indexOf(u.id) == -1

    vm.moveUser = (from, to, index) ->
      to.push(from.splice(index, 1)[0])

    # TODO: move to factory/service
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
