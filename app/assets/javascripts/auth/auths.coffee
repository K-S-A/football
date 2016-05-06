'use strict'

angular.module('mainApp').factory 'auths', [
  '$timeout'
  '$http'
  'Auth'
  ($timeout, $http, Auth) ->
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

    o.watchLoginChange = ->
      FB.Event.subscribe 'auth.authResponseChange', (res) ->
        if res.status == 'connected'
          $http.post('/users/auth/facebook/callback', res).then ->
            Auth.login()

#    o.watchVkLoginChange = ->
#      VK.Observer.subscribe "auth.login", (res) ->
#        console.log(VK.Auth.getSession())
#        #console.log(res)

        #$http.post('/users/auth/vkontakte/callback', res).then ->
        #  console.log(res)
        #  Auth.login()

    o
]
