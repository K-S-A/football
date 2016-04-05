'use strict'

angular.module('mainApp').factory 'auths', [
  '$timeout'
  '$http'
  ($timeout, $http) ->
    o =
      user: {}
      email_pattern: '^([a-z0-9_.-]+@[a-z]+\\.[a-z]{2,5})$'

    o.setUser = (user, message) ->
      user.notice = message
      angular.copy(user, o.user)
      rmMessage()
      return

    o.showAlert = (message) ->
      o.user.alert = message
      rmMessage()
      return

    o.updateUser = (user) ->
      $http.patch('/users.json', user: user)

    rmMessage = ->
      $timeout ->
        u = o.user
        u.alert = u.notice = null
      , 5000
      return

    o
]