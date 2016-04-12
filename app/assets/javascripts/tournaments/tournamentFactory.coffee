'use strict'

angular.module('mainApp').factory 'Tournament', [
  'railsResourceFactory'
  'railsSerializer'
  (railsResourceFactory, railsSerializer) ->
    Tournament = railsResourceFactory(
      url: '/tournaments'
      name: 'tournament'
      serializer: railsSerializer ->
        @only 'id', 'name', 'status', 'sportsKind', 'teamSize', 'users', 'userIds'
        @resource 'teams', 'Team')

    Tournament.beforeRequest (data) ->
      if data && data['users']
        data['user_ids'] = data['users'].map (u) ->
          u.id
        delete data['users']
        data

    Tournament.toTitle = (tournament) ->
      '"' + tournament.name + '" (' + tournament.teamSize + 'x' + tournament.teamSize + ' ' + tournament.sportsKind + ')'

    Tournament
]
