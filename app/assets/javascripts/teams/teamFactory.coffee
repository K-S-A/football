'use strict'

angular.module('mainApp').factory 'Team', [
  'railsResourceFactory'
  'railsSerializer'
  (railsResourceFactory, railsSerializer) ->
    Team = railsResourceFactory(
      url: '/teams'
      name: 'team'
      serializer: railsSerializer ->
        @only 'id', 'name', 'team_size', 'users')

    # TODO: move to separate serializer
    Team.beforeRequest (data) ->
      if data && data['users']
        data['user_ids'] = data['users'].map (u) ->
          u.id
        delete data['users']
        data

    Team

]
