'use strict'

angular.module('mainApp').controller 'AuthCtrl', [
  '$state'
  'Auth'
  'auths'
  ($state, Auth, auths) ->
    vm = this

    vm.user = auths.user
    vm.signedIn = Auth.isAuthenticated
    vm.email_pattern = auths.email_pattern

    vm.login = ->
      Auth.login(vm.user).then (user) ->
        $state.go 'tournaments'
      , (error) ->
        auths.showAlert('Wrong user credentials. Check e-mail/password and try again.')
      return

    vm.register = ->
      Auth.register(vm.user).then (user) ->
        auths.setUser(user, 'You are registered successfully.')
        $state.go 'tournaments'
      return

    vm.logout = ->
      Auth.logout().then ->
        auths.setUser({}, 'You are signed out now.')
        $state.reload()
      return

    vm.update = (user) ->
      auths.updateUser(user)

    vm
]
