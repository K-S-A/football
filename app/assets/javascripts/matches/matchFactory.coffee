'use strict'

angular.module('mainApp').factory 'Match', [
  'railsResourceFactory'
  'railsSerializer'
  (railsResourceFactory, railsSerializer) ->
    Match = railsResourceFactory(
      url: 'rounds/{{roundId}}/matches/{{id}}'
      name: 'match'
      serializer: railsSerializer ->
        # TODO: possible issues
        @only 'id', 'hostTeamId', 'guestTeamId', 'hostScore', 'guestScore', 'teams', 'teamIds', 'count')

    Match.beforeRequest (data) ->
      if data
        data['host_team_id'] ||= data.hostTeam && data.hostTeam.id
        data['guest_team_id'] ||= data.guestTeam && data.guestTeam.id

      data

    Match
]
