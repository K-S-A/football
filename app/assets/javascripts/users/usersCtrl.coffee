'use strict'

angular.module('mainApp').controller 'UsersCtrl', [
  'Auth'
  'auths'
  'User'
  (Auth, auths, User) ->
    vm = this

    vm.user = User.current

    vm
]
