'use strict'

angular.module('mainApp').controller 'UsersCtrl', [
  'Tournament'
  'User'
  'auths'
  (Tournament, User, auths) ->
    vm = this

    vm.user = User.current
    vm.tournaments = vm.user.tournaments.map (params) ->
      new Tournament(params)

    vm.update = (user) ->
      auths.updateUser(user)

    vm
]
