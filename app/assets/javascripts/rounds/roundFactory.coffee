'use strict'

angular.module('mainApp').factory 'Round', [
  'railsResourceFactory'
  'railsSerializer'
  (railsResourceFactory, railsSerializer) ->
    Round = railsResourceFactory(
      url: 'tournaments/{{tournamentId}}/rounds/{{id}}'
      name: 'round'
      serializer: railsSerializer ->
        @only 'id', 'mode', 'position', 'teams', 'teamIds', 'teamId')

    Round.beforeRequest (data) ->
      if data && data['teams']
        data['team_ids'] = data['teams'].map (team) ->
          team.id
        delete data['teams']

      data

    Round.prototype.removeTeam = (team_id) ->
      Round.$delete('/rounds/' + @id + '/teams/' + team_id).then (data) ->
        Round.current.teams = data.teams

    Round
]
