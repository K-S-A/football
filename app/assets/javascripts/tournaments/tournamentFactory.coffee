'use strict'

angular.module('mainApp').factory 'Tournament', [
  'railsResourceFactory'
  'railsSerializer'
  (railsResourceFactory, railsSerializer) ->
    Tournament = railsResourceFactory(
      url: '/tournaments'
      name: 'tournament'
      serializer: railsSerializer ->
        @only 'id', 'name', 'status', 'gameType', 'teamSize', 'users')

    Tournament.beforeRequest (data) ->
      if data && data['users']
        data['user_ids'] = data['users'].map (u) ->
          u.id
        delete data['users']
        data

    Tournament
]
