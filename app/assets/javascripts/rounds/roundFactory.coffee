'use strict'

angular.module('mainApp').factory 'Round', [
  'railsResourceFactory'
  'railsSerializer'
  (railsResourceFactory, railsSerializer) ->
    Round = railsResourceFactory(
      url: 'tournaments/{{tournamentId}}/rounds/{{id}}'
      name: 'round'
      serializer: railsSerializer ->
        @only 'id', 'mode', 'position', 'teams', 'teamIds')

    Round.beforeRequest (data) ->
      if data && data['teams']
        data['team_ids'] = data['teams'].map (team) ->
          team.id
        delete data['teams']

      data

    Round
]
