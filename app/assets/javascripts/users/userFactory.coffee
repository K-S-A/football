'use strict'

angular.module('mainApp').factory 'User', [
  'railsResourceFactory'
  (railsResourceFactory) ->
    User = railsResourceFactory(
      url: '/users',
      name: 'user')

    User.getParticipants = (tournament_id, user_id) ->
      User.$get('/tournaments/' + tournament_id + '/users', user_id: user_id).then (data) ->
        data = data.filter (u) ->
          u.id != user_id
        User.participants = data

    User

]
